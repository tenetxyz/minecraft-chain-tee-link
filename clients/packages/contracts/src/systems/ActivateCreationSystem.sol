// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { PositionComponent, ID as PositionComponentID } from "../components/PositionComponent.sol";
import { ItemComponent, ID as ItemComponentID } from "../components/ItemComponent.sol";
import { OwnedByComponent, ID as OwnedByComponentID } from "../components/OwnedByComponent.sol";
import { CreationOwnerComponent, ID as CreationOwnerComponentID } from "../components/CreationOwnerComponent.sol";
import { CreationBlocksComponent, ID as CreationBlocksComponentID, OpcBlock} from "../components/CreationBlocksComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { VoxelCoord } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";

uint256 constant ID = uint256(keccak256("system.ActivateCreation"));

contract ActivateCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (uint256 creationId, VoxelCoord memory lowerSouthwestCoord) = abi.decode(arguments, (uint256, VoxelCoord));
        // use msg.sender

        // Initialize components
        CreationOwnerComponent creationOwnerComponent = CreationOwnerComponent(getAddressById(components, CreationOwnerComponentID));
        PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));
        CreationBlocksComponent creationBlocksComponent = CreationBlocksComponent(getAddressById(components, CreationBlocksComponentID));

        // require creation to be owned by caller
        // TODO: Allow people other than the owner to activate creations
        require(creationOwnerComponent.getValue(creationId) == msg.sender, "creation is now owned by player");

        // before spawning the creation at the lowerSouthwestCoord, we need to verify that the area in OPCraft is all air
        OpcBlock[] memory opcBlocks = creationBlocksComponent.unmarshalBlocks(creationBlocksComponent.getValue(creationId));
        for(uint32 i= 0; i < opcBlocks.length;i++){
            OpcBlock memory opcBlock = opcBlocks[i];
            VoxelCoord memory coord = VoxelCoord({
                x: lowerSouthwestCoord.x + opcBlock.x,
                y: lowerSouthwestCoord.y + opcBlock.y,
                z: lowerSouthwestCoord.z + opcBlock.z
            });

            // now that we have the coord of the block in OPCraft, verify that it's air
            uint256[] memory entitiesAtPosition = positionComponent.getEntitiesWithValue(coord);
            require(entitiesAtPosition.length == 0 || entitiesAtPosition.length == 1, string(abi.encodePacked("An entity at coord is non-empty: ", coord.x, ",", coord.y, ",", coord.z)));
            if (entitiesAtPosition.length == 1) {
                ItemComponent itemComponent = ItemComponent(getAddressById(components, ItemComponentID));
                require(itemComponent.getValue(entitiesAtPosition[0]) == AirID, string(abi.encodePacked("All blocks in the volume the creation occupies must be air. This block is not air: ", coord.x, ",", coord.y, ",", coord.z)));
            }
        }

        // TODO: check chunk claim? We need to verify all chunks in the selection belong to the player
        // TODO: check user's resources and remove user's resources
        // TODO: set the position of all the blocks in the creation so it shows up on OPCraft. We don't need to update it, just show it
    }

    function executeTyped(uint256 creationId, VoxelCoord memory lowerSouthwestCoord) public returns (bytes memory) {
        return execute(abi.encode(creationId, lowerSouthwestCoord));
    }
}
