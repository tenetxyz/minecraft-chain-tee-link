// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/AddressBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.CreationOwner"));

// maps the creation -> owner (a wallet id)
contract CreationOwnerComponent is AddressBareComponent {
    constructor(address world) AddressBareComponent(world, ID) {}
}