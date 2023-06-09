// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/Uint256ArrayBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.Blocks"));

// maps the creationId -> blocks in that creation
contract BlocksComponent is Uint256ArrayBareComponent {
    constructor(address world) Uint256ArrayBareComponent(world, ID) {}

    function addBlock(uint256 entityId, uint256 blockEntityId) public virtual {
        bytes memory oldBlocksBytes = getRawValue(entityId);
        uint256[] memory oldBlocks = oldBlocksBytes.length == 0 ? new uint256[](0) : abi.decode(oldBlocksBytes, (uint256[]));
        uint256[] memory newBlocks = new uint256[](oldBlocks.length + 1);
        for (uint256 i = 0; i < oldBlocks.length; i++) {
            newBlocks[i] = oldBlocks[i];
        }
        newBlocks[oldBlocks.length] = blockEntityId;
        set(entityId, abi.encode(newBlocks));
    }
}