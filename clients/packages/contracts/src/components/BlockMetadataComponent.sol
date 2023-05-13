// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/BareComponent.sol";
import "../types.sol";

uint256 constant ID = uint256(keccak256("component.BlockMetadata"));

// used to map a block -> it's metadata
contract BlockMetadataComponent is BareComponent {
    constructor(address world) BareComponent(world, ID) {}

    function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
        keys = new string[](2);
        values = new LibTypes.SchemaValue[](2);

        keys[0] = "blockFace";
        values[0] = LibTypes.SchemaValue.UINT8;

        keys[1] = "blockType";
        values[1] = LibTypes.SchemaValue.UINT256;
    }

    function set(uint256 entity, BlockFace blockFace, uint256 blockType) public {
        set(entity, abi.encode(uint8(blockFace), blockType));
    }

    function getBlockFace(uint256 entity) public view returns (BlockFace) {
        (uint8 blockFace, uint256 blockType) = abi.decode(getRawValue(entity), (uint8, uint256));
        return BlockFace(blockFace);
    }

    function getBlockType(uint256 entity) public view returns (uint256) {
        (uint8 blockFace, uint256 blockType) = abi.decode(getRawValue(entity), (uint8, uint256));
        return blockType;
    }
}

