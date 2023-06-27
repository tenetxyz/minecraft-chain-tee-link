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

        // TODO: find some way to convert the blockType to a uint256 to save space
        keys[1] = "material";
        values[1] = LibTypes.SchemaValue.STRING;
    }

    function set(uint256 entity, BlockFace blockFace, string memory material) public {
        set(entity, abi.encode(uint8(blockFace), material));
    }

    function getBlockFace(uint256 entity) public view returns (BlockFace) {
        (uint8 blockFace, string memory material) = abi.decode(getRawValue(entity), (uint8, string));
        return BlockFace(blockFace);
    }

    function getMaterial(uint256 entity) public view returns (string memory) {
        (uint8 blockFace, string memory material) = abi.decode(getRawValue(entity), (uint8, string));
        return material;
    }
}

