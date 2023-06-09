// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import "../libraries/Utils.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { PositionComponent, ID as PositionComponentID } from "../components/PositionComponent.sol";
import { ActivatedCreationsComponent, ID as ActivatedCreationsComponentID } from "../components/ActivatedCreationsComponent.sol";
import { ItemComponent, ID as ItemComponentID } from "../components/ItemComponent.sol";
import { OwnedByComponent, ID as OwnedByComponentID } from "../components/OwnedByComponent.sol";
import { BlocksComponent, ID as BlocksComponentID} from "../components/BlocksComponent.sol";
import { OfCreationComponent, ID as OfCreationComponentID} from "../components/OfCreationComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { VoxelCoord, OpcBlock } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";
import { PinkWoolID } from "../prototypes/Blocks.sol";

uint256 constant ID = uint256(keccak256("system.ActivateCreation"));

contract ActivateCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (uint256 creationId, VoxelCoord memory lowerSouthwestCoord) = abi.decode(arguments, (uint256, VoxelCoord));

        // Initialize components
        OwnedByComponent ownedByComponent = OwnedByComponent(getAddressById(components, OwnedByComponentID));
        BlocksComponent blocksComponent = BlocksComponent(getAddressById(components, BlocksComponentID));
        OfCreationComponent ofCreationComponent = OfCreationComponent(getAddressById(components, OfCreationComponentID));
        PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));
        ActivatedCreationsComponent activatedCreationsComponent = ActivatedCreationsComponent(getAddressById(components, ActivatedCreationsComponentID));

        // require creation to be owned by caller
        // TODO: Allow people other than the owner to activate creations

        require(ownedByComponent.getValue(creationId) == addressToEntity(msg.sender), "You must own this creation to activate it");

        VoxelCoord[] memory coordsInOpCraft = calculateCreationCoordsAfterPlacing(creationId, lowerSouthwestCoord, blocksComponent, positionComponent);

        // before spawning the creation at the lowerSouthwestCoord, we need to verify that the area in OPCraft is all air
        for(uint32 i = 0; i < coordsInOpCraft.length; i++){
            VoxelCoord memory coord = coordsInOpCraft[i];
            // now that we have the coord of the block in OPCraft, verify that it's air
            uint256[] memory entitiesAtPosition = positionComponent.getEntitiesWithValue(coord);
            require(entitiesAtPosition.length == 0 || entitiesAtPosition.length == 1, string(abi.encodePacked("An entity at coord is non-empty: ", Utils.int32ToString(coord.x), ",", Utils.int32ToString(coord.y), ",", Utils.int32ToString(coord.z))));
            if (entitiesAtPosition.length == 1) {
                ItemComponent itemComponent = ItemComponent(getAddressById(components, ItemComponentID));
                require(itemComponent.getValue(entitiesAtPosition[0]) == AirID, string(abi.encodePacked("All blocks in the volume the creation occupies must be air. This block is not air: ", Utils.int32ToString(coord.x), ",", Utils.int32ToString(coord.y), ",", Utils.int32ToString(coord.z))));
            }
        }

        // TODO: check chunk claim? We need to verify all chunks in the selection belong to the player
        // TODO: check user's resources and remove user's resources
        uint256 activatedCreationId = world.getUniqueEntityId();
        positionComponent.set(activatedCreationId, lowerSouthwestCoord);
        ofCreationComponent.set(activatedCreationId, creationId); // this activated creation is "part of" this creation
        activatedCreationsComponent.addCreation(addressToEntity(msg.sender), activatedCreationId);

        // Set the position of all the blocks in the creation so it shows up on OPCraft. We don't need to update it, just show it
        // TODO: update this to show the actual blocks when we've added more blocks
        for(uint32 i = 0; i < coordsInOpCraft.length; i++){
            VoxelCoord memory coord = coordsInOpCraft[i];
            positionComponent.set(PinkWoolID, coord);
        }
    }

    function calculateCreationCoordsAfterPlacing(uint256 creationId, VoxelCoord memory lowerSouthwestCoord, BlocksComponent blocksComponent, PositionComponent positionComponent) public returns (VoxelCoord[] memory){
        uint256[] memory opcBlockEntityIds = blocksComponent.getValue(creationId);

        VoxelCoord[] memory coordsInOpCraft = new VoxelCoord[](opcBlockEntityIds.length);
        for(uint32 i= 0; i < opcBlockEntityIds.length; i++){
            uint256 opcBlockEntityId = opcBlockEntityIds[i];
            VoxelCoord memory relativeCoord = positionComponent.getValue(opcBlockEntityId);
            coordsInOpCraft[i] = VoxelCoord({
                x: lowerSouthwestCoord.x + relativeCoord.x,
                y: lowerSouthwestCoord.y + relativeCoord.y,
                z: lowerSouthwestCoord.z + relativeCoord.z
            });
        }
        return coordsInOpCraft;
    }

    function executeTyped(uint256 creationId, VoxelCoord memory lowerSouthwestCoord) public returns (bytes memory) {
        return execute(abi.encode(creationId, lowerSouthwestCoord));
    }
}
