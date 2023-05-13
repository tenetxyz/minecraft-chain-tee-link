// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { BlocksComponent, ID as BlocksComponentID} from "../components/BlocksComponent.sol";
import { BlockMetadataComponent, ID as BlockMetadataComponentID } from "../components/BlockMetadataComponent.sol";
import { OwnedByComponent, ID as OwnedByComponentID } from "../components/OwnedByComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { VoxelCoord, OpcBlock } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";
import { PositionComponent, ID as PositionComponentID } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.RegisterCreation"));

uint256 constant MAX_BLOCKS_IN_CREATION = 100;

contract RegisterCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (OpcBlock[] memory opcBlocks) = abi.decode(arguments, (OpcBlock[]));
        // Initialize components
        BlocksComponent blocksComponent = BlocksComponent(getAddressById(components, BlocksComponentID));
        BlockMetadataComponent blockMetadataComponent = BlockMetadataComponent(getAddressById(components, BlockMetadataComponentID));
        OwnedByComponent ownedByComponent = OwnedByComponent(getAddressById(components, OwnedByComponentID));
        PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));

        require(opcBlocks.length <= MAX_BLOCKS_IN_CREATION, string(abi.encodePacked("Your creation cannot exceed ", MAX_BLOCKS_IN_CREATION, " blocks")));

        // check that this creation hasn't been made before
        uint256 creationEntityId = getCreationHash(opcBlocks);
        require(blocksComponent.has(creationEntityId), string(abi.encodePacked("This creation has already been created. The entity with the same blocks is ", "This creation's entityId is " , creationEntityId)));

        // now we can safely make this new creation
        OpcBlock[] memory repositionedOpcBlocks = repositionBlocksSoLowerSouthwestCornerIsOnOrigin(opcBlocks);

        for(uint32 i = 0; i < repositionedOpcBlocks.length; i++){
            uint256 blockEntityId = world.getUniqueEntityId();

            OpcBlock memory repositionedOpcBlock = repositionedOpcBlocks[i];
            positionComponent.set(blockEntityId, repositionedOpcBlock.relativeCoord);
            blockMetadataComponent.set(blockEntityId, repositionedOpcBlock.blockFace, repositionedOpcBlock.blockType);

            blocksComponent.addBlock(creationEntityId, blockEntityId);
        }
        ownedByComponent.set(creationEntityId, addressToEntity(msg.sender));

        return abi.encode(creationEntityId);
    }

    function executeTyped(address creationOwner, OpcBlock[] memory opcBlocks) public returns (bytes memory) {
        return execute(abi.encode(creationOwner, opcBlocks));
    }

    function repositionBlocksSoLowerSouthwestCornerIsOnOrigin(OpcBlock[] memory opcBlocks) private returns (OpcBlock[] memory){
        OpcBlock[] memory repositionedOpcBlocks = new OpcBlock[](opcBlocks.length);
        int32 lowestX = 0;
        int32 lowestY = 0;
        int32 lowestZ = 0;
        for (uint32 i = 0; i < opcBlocks.length; i++) {
            OpcBlock memory opcBlock = opcBlocks[i];
            if (opcBlock.relativeCoord.x < lowestX) {
                lowestX = opcBlock.relativeCoord.x;
            }
            if (opcBlock.relativeCoord.y < lowestY) {
                lowestY = opcBlock.relativeCoord.y;
            }
            if (opcBlock.relativeCoord.z < lowestZ) {
                lowestZ = opcBlock.relativeCoord.z;
            }
        }

        for (uint32 i = 0; i < opcBlocks.length; i++) {
            OpcBlock memory opcBlock = opcBlocks[i];
            VoxelCoord memory newRelativeCoord = VoxelCoord(opcBlock.relativeCoord.x - lowestX, opcBlock.relativeCoord.y - lowestY, opcBlock.relativeCoord.z - lowestZ);
            repositionedOpcBlocks[i] = OpcBlock(newRelativeCoord, opcBlock.blockFace, opcBlock.blockType);
        }
        return repositionedOpcBlocks;
    }

    function getCreationHash(OpcBlock[] memory opcBlocks) public returns (uint256) {
        return uint256(keccak256(abi.encode(opcBlocks)));
    }
}
