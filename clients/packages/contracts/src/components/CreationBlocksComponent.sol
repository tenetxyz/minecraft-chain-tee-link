// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/Uint256ArrayBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.CreationBlocks"));

// The block in memory is laid out like so:
// the first 96 bits are the coords
// the next 8 bits are the face
// the next 256 - 104 bits are unused
// the next 256 bits are the block type
uint8 constant NumIndicesPerBlock = 2;
struct OpcBlock { // OpcBlock = OPCraft block. we cannot use the word "Block" since it's a reserved keyword
    int32 x;
    int32 y;
    int32 z;
    uint8 blockFace;
    uint256 blockType;
}

// maps the creation -> blocks (array of uint256)
// each block takes up two indexes in the array: blockType and blockFace (blockFace only is only 6 possible values). A waste, but it's fine
contract CreationBlocksComponent is Uint256ArrayBareComponent {
    constructor(address world) Uint256ArrayBareComponent(world, ID) {}

    // Return the struct from a function
    function unmarshalBlocks(uint256[] memory blockBytes) public pure returns (OpcBlock[] memory) {
        OpcBlock[] memory opcBlocks = new OpcBlock[](blockBytes.length / NumIndicesPerBlock);
        for (uint32 i = 0; i < blockBytes.length; i += NumIndicesPerBlock) {
            OpcBlock memory opcBlock;
            opcBlock.x = int32(int256(blockBytes[i] >> 96 + 128) & 0xFFFFFFFF);
            opcBlock.y = int32(int256(blockBytes[i] >> 64 + 128) & 0xFFFFFFFF);
            opcBlock.z = int32(int256(blockBytes[i] >> 32 + 128) & 0xFFFFFFFF);
            opcBlock.blockFace = uint8(uint256(blockBytes[i] >> 128) & 0xFFFFFFFF);
            opcBlock.blockType = blockBytes[i + 1];
            opcBlocks[i / NumIndicesPerBlock] = opcBlock;
        }
        return opcBlocks;
    }
}
