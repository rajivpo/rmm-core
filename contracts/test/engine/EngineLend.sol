// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.0;

import "../../interfaces/IPrimitiveEngine.sol";
import "../../interfaces/IERC20.sol";

contract EngineLend {

    address public engine;
    address public risky;
    address public stable;
    address public CALLER;

    constructor() {}

    function initialize(address _engine, address _risky, address _stable) public {
      engine = _engine;
      risky = _risky;
      stable = _stable;
    }

    function lend(bytes32 pid, uint dLiquidty) public {
      IPrimitiveEngine(engine).lend(pid, dLiquidty);
    }

    function getPosition(bytes32 pid) public view returns(bytes32 posid) {
        posid = keccak256(abi.encodePacked(address(this), pid));
    }

    function name() public view returns (string memory) {
      return "EngineLend";
    }
}
