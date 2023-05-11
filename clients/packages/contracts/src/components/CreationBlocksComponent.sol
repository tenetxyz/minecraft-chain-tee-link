// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/BoolBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.CreationOwner"));

// maps the creation -> blocks (array of uint256)
contract CreationOwnerComponent is AddressBareComponent {
    constructor(address world) BoolBareComponent(world, ID) {}
}