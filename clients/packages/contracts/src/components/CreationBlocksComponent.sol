// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/Uint256ArrayBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.CreationBlocks"));

// maps the creation -> blocks (array of uint256)
// each block takes up two indexes in the array: blockType and blockFace (blockFace only is only 6 possible values). A waste, but it's fine
contract CreationBlocksComponent is Uint256ArrayBareComponent {
    constructor(address world) Uint256ArrayBareComponent(world, ID) {}
}

// The block in memory is laid out like so:
// the first 96 bits are the coords
// the next 8 bits are the face
// the next 256 - 104 bits are unused
// the next 256 bits are the block type
uint8 constant NumIndicesPerBlock = 2;
struct Block {
    int32 x;
    int32 y;
    int32 z;
    uint8 blockFace;
    uint256 blockType;
}

// Return the struct from a function
function unmarshalBlocks(uint256[] memory blockBytes) public pure returns (Block[] memory) {
    Block[] memory blocks = new Block[](blockBytes.length / NumIndicesPerBlock);
    for (uint32 i = 0; i < blockBytes.length; i += NumIndicesPerBlock) {
        Block memory block;
        block.x = int32((blockBytes[i] >> 96 + 128) & 0xFFFFFFFF);
        block.y = int32((blockBytes[i] >> 64 + 128) & 0xFFFFFFFF);
        block.z = int32((blockBytes[i] >> 32 + 128) & 0xFFFFFFFF);
        block.blockFace = uint8((blockBytes[i] >> 128) & 0xFFFFFFFF);
        block.blockType = blockBytes[i + 1];
        blocks[i / NumIndicesPerBlock] = block;
    }
    return blocks;
}