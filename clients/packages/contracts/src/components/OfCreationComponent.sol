// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/Uint256Component.sol";

import { Creation } from "../types.sol";

uint256 constant ID = uint256(keccak256("component.OfCreationComponent"));

// maps block -> creationId
// maps activatedCreation -> creationId
contract OfCreationComponent is Uint256Component {
    constructor(address world) Uint256Component(world, ID) {}
}
