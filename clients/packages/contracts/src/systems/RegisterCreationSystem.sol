// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { CreationComponent, ID as CreationComponentID } from "../components/CreationComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { VoxelCoord, Creation, OpcBlock } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";

uint256 constant ID = uint256(keccak256("system.RegisterCreation"));

contract RegisterCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (OpcBlock[] memory opcBlocks) = abi.decode(arguments, (OpcBlock[]));
        // Initialize components
        CreationComponent creationComponent = CreationComponent(getAddressById(components, CreationComponentID));

        require(opcBlocks.length <= 100, "Your creation cannot exceed 100 blocks");
        // TODO: should we require that all opcBlocks have coords that are non-negative? Or we do assume it's all positive
        // having all nonnegative coords makes it easier since by default, we know where the lowerSouthwest corner is
        
        OpcBlock[] memory repositionedOpcBlocks = repositionBlocksSoLowerSouthwestCornerIsOnOrigin(opcBlocks);

        // assume msg.sender is the creation owner
        Creation memory creation = Creation(msg.sender, repositionedOpcBlocks);

        uint256 creationId = creationComponent.getCreationId(creation); // Note: we only hash the blocks, and not the owner, so we can see if this arrangement has been made before
        require(!creationComponent.has(creationId), string(abi.encodePacked("This creation has already been created. The owner is ", creationComponent.getValue(creationId).owner , ". This creation's id is " , creationId)));

        creationComponent.set(creationId, creation);
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
}
