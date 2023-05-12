// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { OwnedByComponent, ID as OwnedByComponentID } from "../components/OwnedByComponent.sol";

uint256 constant ID = uint256(keccak256("system.CollectResources"));

contract CollectResourcesSystem is System {

    constructor(IWorld _world, address _components) System(_world, _components) {}
    function execute(bytes memory arguments) public returns (bytes memory) {
        (uint256 receiver, uint256 resourceType, uint256 resourceAmount) = abi.decode(arguments, (uint256, uint256, uint256));

        require(msg.sender == GOD_ADDRESS, "Only the god address can give people resources via this contract");

        // init components
        OwnedByComponent ownedByComponent = OwnedByComponent(getAddressById(components, OwnedByComponentID));

        for (uint256 i; i < entitiesAtPosition.length; i++) {
            entity = world.getUniqueEntityId();
            ownedByComponent.set(entity, receiver);
        }
    }

    function executeTyped(uint256 entity, uint256 resourceType, uint256 resourceAmount) public returns (bytes memory) {
        return execute(abi.encode(entity, resourceType));
    }
}