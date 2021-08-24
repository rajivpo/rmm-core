// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

/// @title  Primitive Borrow Callback
/// @author Primitive

interface IPrimitiveBorrowCallback {
    /// @notice                 Triggered when borrowing liquidity from an Engine
    /// @param  riskyDeficit    Amount of risky tokens required to be paid to the Engine
    /// @param  stableDeficit   Amount of stable tokens required to be paid to the Engine
    /// @param  data            Calldata passed on borrow function call
    function borrowCallback(
        uint256 riskyDeficit,
        uint256 stableDeficit,
        bytes calldata data
    ) external;
}
