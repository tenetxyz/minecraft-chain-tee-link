// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { PositionComponent, ID as PositionComponentID } from "../components/PositionComponent.sol";
import { ActivatedCreationsComponent, ID as ActivatedCreationsComponentID } from "../components/ActivatedCreationsComponent.sol";
import { ItemComponent, ID as ItemComponentID } from "../components/ItemComponent.sol";
import { OwnedByComponent, ID as OwnedByComponentID } from "../components/OwnedByComponent.sol";
import { CreationComponent, ID as CreationComponentID} from "../components/BlocksComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { VoxelCoord, Creation, OpcBlock, ActivatedCreation } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";
import { PinkWoolID } from "../prototypes/Blocks.sol";

uint256 constant ID = uint256(keccak256("system.ActivateCreation"));

contract ActivateCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (uint256 creationId, VoxelCoord memory lowerSouthwestCoord) = abi.decode(arguments, (uint256, VoxelCoord));

        // Initialize components
        BlocksComponent creationComponent = CreationComponent(getAddressById(components, CreationComponentID));
        ActivatedCreationsComponent activatedCreationsComponent = ActivatedCreationsComponent(getAddressById(components, ActivatedCreationsComponentID));
        PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));

        // require creation to be owned by caller
        // TODO: Allow people other than the owner to activate creations
        Creation memory creation = creationComponent.getValue(creationId);
        require(creation.owner == msg.sender, "You must own this creation to activate it");

        VoxelCoord[] memory coordsInOpCraft = calculateCreationCoordsAfterPlacing(creation, lowerSouthwestCoord);

        // before spawning the creation at the lowerSouthwestCoord, we need to verify that the area in OPCraft is all air
        for(uint32 i = 0; i < coordsInOpCraft.length; i++){
            VoxelCoord memory coord = coordsInOpCraft[i];
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

        activatedCreationsComponent.addCreation(addressToEntity(msg.sender), ActivatedCreation(lowerSouthwestCoord, creationId));

        // Set the position of all the blocks in the creation so it shows up on OPCraft. We don't need to update it, just show it
        // TODO: update this to show the actual blocks when we've added more blocks
        for(uint32 i = 0; i < coordsInOpCraft.length; i++){
            VoxelCoord memory coord = coordsInOpCraft[i];
            positionComponent.set(PinkWoolID, coord);
        }
    }

    function calculateCreationCoordsAfterPlacing(Creation memory creation, VoxelCoord memory lowerSouthwestCoord) public returns (VoxelCoord[] memory){
        OpcBlock[] memory opcBlocks = creation.opcBlocks;
        VoxelCoord[] memory coordsInOpCraft = new VoxelCoord[](opcBlocks.length);
        for(uint32 i= 0; i < opcBlocks.length; i++){
            OpcBlock memory opcBlock = opcBlocks[i];
            coordsInOpCraft[i] = VoxelCoord({
                x: lowerSouthwestCoord.x + opcBlock.relativeX,
                y: lowerSouthwestCoord.y + opcBlock.relativeY,
                z: lowerSouthwestCoord.z + opcBlock.relativeZ
            });
        }
        return coordsInOpCraft;
    }

    function executeTyped(uint256 creationId, VoxelCoord memory lowerSouthwestCoord) public returns (bytes memory) {
        return execute(abi.encode(creationId, lowerSouthwestCoord));
    }
}
