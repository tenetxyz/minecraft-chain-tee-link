// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/BareComponent.sol";

enum BlockFace { // BlockFace = the face of a block. These enum values were taken from the bukkit codebase
    NORTH,
    SOUTH,
    EAST,
    WEST,
    TOP,
    BOTTOM
}

struct OpcBlock { // OpcBlock = OPCraft block. we cannot use the word "Block" since it's a reserved keyword
    int32 relativeX; // these coords are relative to the lower-south-west corner of the creation
    int32 relativeY;
    int32 relativeZ;
    uint8 BlockFace;
    uint256 blockType; // search for this in the bukkit codebase to find the block type: NORTH((byte)0, (byte)0, (byte)-1, BlockFace.EnumAxis.Z),
}

struct Creation {
    address owner;
    OpcBlock[] opcBlocks;
}

contract CreationBareComponent is BareComponent {
    constructor(address world, uint256 id) BareComponent(world, id) {}

    function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
        keys = new string[](2);
        values = new LibTypes.SchemaValue[](2);

        keys[0] = "owner";
        values[0] = LibTypes.SchemaValue.ADDRESS;

        keys[1] = "opcBlocks";
        values[1] = LibTypes.SchemaValue.BYTES;
    }

    function set(uint256 entity, Creation calldata value) public virtual {
        set(entity, abi.encode(value));
    }

    function getValue(uint256 entity) public view virtual returns (Creation memory) {
        (Creation memory creation) = abi.decode(getRawValue(entity), (Creation));
        return creation;
    }
}
