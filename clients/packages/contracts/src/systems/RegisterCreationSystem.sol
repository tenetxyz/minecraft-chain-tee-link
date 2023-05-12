// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { BlocksComponent, ID as BlocksComponentID } from "../components/BlocksComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { HashComponent, ID as HashComponentID} from "../components/HashComponent.sol";
import { VoxelCoord, Creation, OpcBlock } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";

uint256 constant ID = uint256(keccak256("system.RegisterCreation"));

uint256 constant MAX_BLOCKS_IN_CREATION = 100;

contract RegisterCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (OpcBlock[] memory opcBlocks) = abi.decode(arguments, (OpcBlock[]));
        // Initialize components
        BlocksComponent blocksComponent = BlocksComponent(getAddressById(components, BlocksComponentID));
        OwnedByComponent ownedByComponent = OwnedByComponent(getAddressById(components, OwnedByComponentID));

        require(opcBlocks.length <= MAX_BLOCKS_IN_CREATION, string(abi.encodePacked("Your creation cannot exceed ", MAX_BLOCKS_IN_CREATION, " blocks")));

        // check that this creation hasn't been made before
        uint256 creationEntityId = getCreationHash(opcBlocks);
        require(blocksComponent.has(creationEntityId) == 0, string(abi.encodePacked("This creation has already been created. The entity with the same blocks is ", "This creation's entityId is " , creationEntityId)));

        // now we can safely make this new creation
        OpcBlock[] memory repositionedOpcBlocks = repositionBlocksSoLowerSouthwestCornerIsOnOrigin(opcBlocks);
        blocksComponent.set(creationEntityId, repositionedOpcBlocks);
        ownedByComponent.set(creationEntityId, addressToEntity(msg.sender));
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
            if (opcBlock.relativeX < lowestX) {
                lowestX = opcBlock.relativeX;
            }
            if (opcBlock.relativeY < lowestY) {
                lowestY = opcBlock.relativeY;
            }
            if (opcBlock.relativeZ < lowestZ) {
                lowestZ = opcBlock.relativeZ;
            }
        }

        for (uint32 i = 0; i < opcBlocks.length; i++) {
            OpcBlock memory opcBlock = opcBlocks[i];
            repositionedOpcBlocks[i] = OpcBlock(opcBlock.relativeX - lowestX, opcBlock.relativeY - lowestY, opcBlock.relativeZ - lowestZ, opcBlock.blockFace, opcBlock.blockType);
        }
        return repositionedOpcBlocks;
    }

    function getCreationHash(OpcBlock[] memory opcBlocks) public returns (uint256) {
        return uint256(keccak256(abi.encode(opcBlocks)));
    }
}
