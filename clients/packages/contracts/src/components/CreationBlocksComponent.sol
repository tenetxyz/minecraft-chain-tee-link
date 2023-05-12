// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/Uint256ArrayBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.CreationBlocks"));

// maps the creation -> blocks (array of uint256)
// each block takes up two indexes in the array: blockType and blockFace (blockFace only is only 6 possible values). A waste, but it's fine
contract CreationBlocksComponent is Uint256ArrayBareComponent {
    constructor(address world) Uint256ArrayBareComponent(world, ID) {}
}