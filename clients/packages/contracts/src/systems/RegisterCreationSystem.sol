// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { PositionComponent, ID as PositionComponentID } from "../components/PositionComponent.sol";
import { ItemComponent, ID as ItemComponentID } from "../components/ItemComponent.sol";
import { OwnedByComponent, ID as OwnedByComponentID } from "../components/OwnedByComponent.sol";
import { ClaimComponent, ID as ClaimComponentID, Claim } from "../components/ClaimComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { VoxelCoord } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";
import "../components/CreationOwnerComponent.sol";
import "../components/CreationBlocksComponent.sol";

uint256 constant ID = uint256(keccak256("system.RegisterCreation"));

contract RegisterCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (uint256 creationOwner, uint256[] memory blocks) = abi.decode(arguments, (uint256, VoxelCoord));

        // we are not using msg.sender to register the creationOwner since it's coming from the mc server
        // This MC server is trusted to register creations on behalf of the player

        // Initialize components
        CreationOwnerComponent creationOwnerComponent = CreationOwnerComponent(getAddressById(components, CreationOwnerComponentID));
        CreationBlocksComponent creationBlocksComponent = CreationBlocksComponent(getAddressById(components, CreationBlocksComponentID));

        require(blocks.length <= 200, "Your creation cannot exceed 100 blocks");

        uint256 memory creationId = uint256(keccak256(blocks)); // Note: we only hash the blocks, and not the owner, so we can see if this arrangement has been made before
        require(!creationOwnerComponent.has(creationId), "This creation has already been created by " + creationOwnerComponent.get(creationId) + ". This creation's id is " + creationId);

        creationOwnerComponent.setValue(creationId, creationOwner);
        creationBlocksComponent.setValue(creationId, blocks);
    }

    function executeTyped(uint256 creationOwner, uint256[] memory blocks) public returns (bytes memory) {
        return execute(abi.encode(creationOwner, blocks));
    }
}
