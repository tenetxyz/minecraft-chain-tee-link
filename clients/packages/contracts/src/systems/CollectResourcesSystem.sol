// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { ResourceCountComponent, ID as ResourceCountComponentID } from "../components/ResourceCountComponent.sol";

uint256 constant ID = uint256(keccak256("system.CollectResources"));

contract CollectResourcesSystem is System {

    constructor(IWorld _world, address _components) System(_world, _components) {}
    function execute(bytes memory arguments) public returns (bytes memory) {
        (uint256 receiver, uint256 resourceType, uint256 resourceAmount) = abi.decode(arguments, (uint256, uint256, uint256));

        // TODO: only check this after we've demoed end-to-end
        // require(msg.sender == GOD_ADDRESS, "Only the god address can give people resources via this contract");

        // init components
        ResourceCountComponent resourceCountComponent = ResourceCountComponent(getAddressById(components, ResourceCountComponentID));
        resourceCountComponent.updateResourceCount(msg.sender,resourceType, resourceAmount);
    }

    function executeTyped(uint256 entity, uint256 resourceType, uint256 resourceAmount) public returns (bytes memory) {
        return execute(abi.encode(entity, resourceType));
    }
}