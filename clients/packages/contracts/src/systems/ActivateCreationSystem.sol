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

uint256 constant ID = uint256(keccak256("system.ActivateCreation"));

contract ActivateCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (uint256 creationId, VoxelCoord memory lowerSouthwestCoord) = abi.decode(arguments, (uint256, VoxelCoord));
        // use msg.sender

        // Initialize components
        CreationOwnerComponent creationOwnerComponent = CreationOwnerComponent(getAddressById(components, CreationOwnerComponentID));

        // TODO: allow people other than the owner to activate creations
        // require creation to be owned by caller
        require(creationOwnerComponent.getValue(creationId) == addressToEntity(msg.sender), "creation is now owned by player");

        // spawn the creation at the lowerSouthwestCoord
        // determine the upper north east coord

        // require that all the blocks in the specified location is air

        // Require no other ECS blocks at this position except Air
        uint256[] memory entitiesAtPosition = positionComponent.getEntitiesWithValue(coord);
        require(entitiesAtPosition.length == 0 || entitiesAtPosition.length == 1, "can not built at non-empty coord");
        if (entitiesAtPosition.length == 1) {
            ItemComponent itemComponent = ItemComponent(getAddressById(components, ItemComponentID));
            require(itemComponent.getValue(entitiesAtPosition[0]) == AirID, "can not built at non-empty coord (2)");
        }

        // TODO: check chunk claim? We need to verify all chunks in the selection belong to the player
        // Check claim in chunk
//        uint256 claimer = getClaimAtCoord(claimComponent, coord).claimer;
//        require(claimer == 0 || claimer == addressToEntity(msg.sender), "can not build in claimed chunk");

        // TODO: remove user's resources
    }

    function executeTyped(uint256 creationId, VoxelCoord memory lowerSouthwestCoord) public returns (bytes memory) {
        return execute(abi.encode(creationId, lowerSouthwestCoord));
    }
}
