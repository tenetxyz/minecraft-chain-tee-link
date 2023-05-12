// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/VoxelCoordBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.ActivatedCreation"));

// maps lowerSouthWest corner -> the activated creationId at that coord
contract ActivatedCreationComponent is VoxelCoordComponent {
    constructor(address world) VoxelCoordComponent(world, ID) {}
}