// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.0;

import "../../libraries/Reserve.sol";

/// @title   Reserve Lib API Test
/// @author  Primitive
/// @dev     For testing purposes ONLY

contract TestReserve {
    using Reserve for Reserve.Data;
    using Reserve for mapping(bytes32 => Reserve.Data);
    
    /// @notice Used for testing time
    uint256 public timestamp;
    /// @notice Storage slot for the reserveId used for testing
    bytes32 public reserveId;
    /// @notice All the reserve data structs to use for testing
    mapping(bytes32 => Reserve.Data) public reserves;
    
    constructor() {}

   /// @notice Used for testing
    function res() public view returns (Reserve.Data memory) {
       return reserves[reserveId];
    }

    /// @notice Called before each unit test to initialize a reserve to test
    function beforeEach(string memory name, uint timestamp_, uint reserveRisky, uint reserveStable) public {
       timestamp = timestamp_; // set the starting time for this reserve
       bytes32 resId = keccak256(abi.encodePacked(name)); // get bytes32 id for name
       reserveId = resId; // set this resId in global state to easily fetch in test
       // create a new reserve data struct
       reserves[resId] = Reserve.Data({
            RX1: reserveRisky, // risky token balance
            RY2: reserveStable, // stable token balance
            liquidity: 2e18,
            float: 1e18, // the LP shares available to be borrowed on a given pid
            debt: 0, // the LP shares borrowed from the float
            cumulativeRisky: 0,
            cumulativeStable: 0,
            cumulativeLiquidity: 0,
            blockTimestamp: uint32(timestamp_)
       });
    }

   /// @notice Used for time dependent tests
   function _blockTimestamp() public view returns (uint32 blockTimestamp) {
      blockTimestamp = uint32(timestamp);
   }

   /// @notice Increments the timestamp used for testing
   function step(uint timestep) public {
      timestamp += uint32(timestep);
   }

    /// @notice Adds amounts to cumulative reserves
    function shouldUpdate(bytes32 resId) public returns (Reserve.Data memory) {
        return reserves[resId].update(_blockTimestamp());
    }

    /// @notice Increases one reserve value and decreases the other by different amounts
    function shouldSwap(bytes32 resId, bool addXRemoveY, uint deltaIn, uint deltaOut) public returns (Reserve.Data memory) {
        return reserves[resId].swap(addXRemoveY, deltaIn, deltaOut, _blockTimestamp());
    }

    /// @notice Add to both reserves and total supply of liquidity
    function shouldAllocate(bytes32 resId, uint deltaX, uint deltaY, uint deltaL) public returns (Reserve.Data memory) {
       return reserves[resId].allocate(deltaX, deltaY, deltaL, _blockTimestamp());
    }

    /// @notice Remove from both reserves and total supply of liquidity
    function shouldRemove(bytes32 resId, uint deltaX, uint deltaY, uint deltaL) public returns (Reserve.Data memory) {
       return reserves[resId].remove(deltaX, deltaY, deltaL, _blockTimestamp());
    }

    /// @notice Increases available float to borrow, called when lending
    function shouldAddFloat(bytes32 resId, uint deltaL) public returns (Reserve.Data memory) {
       return reserves[resId].addFloat(deltaL);
    }

    /// @notice Reduces available float, taking liquidity off the market, called when claiming
    function shouldRemoveFloat(bytes32 resId, uint deltaL) public returns (Reserve.Data memory) {
       return reserves[resId].removeFloat(deltaL);
    }

    /// @notice Reduces float and increases debt of the global reserve, called when borrowing
    function shouldBorrowFloat(bytes32 resId, uint deltaL) public returns (Reserve.Data memory) {
       return reserves[resId].borrowFloat(deltaL);
    }

    /// @notice Increases float and reduces debt of the global reserve, called when repaying a borrow 
    function shouldRepayFloat(bytes32 resId, uint deltaL) public returns (Reserve.Data memory) {
       return reserves[resId].repayFloat(deltaL);
    }
}