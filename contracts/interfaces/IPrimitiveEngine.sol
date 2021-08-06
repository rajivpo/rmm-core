// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;
pragma abicoder v2;

import "./engine/IPrimitiveEngineActions.sol";
import "./engine/IPrimitiveEngineEvents.sol";
import "./engine/IPrimitiveEngineView.sol";
import "./engine/IPrimitiveEngineErrors.sol";

interface IPrimitiveEngine is
    IPrimitiveEngineActions,
    IPrimitiveEngineEvents,
    IPrimitiveEngineView,
    IPrimitiveEngineErrors
{}
