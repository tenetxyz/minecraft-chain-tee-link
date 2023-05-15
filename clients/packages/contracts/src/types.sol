// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import { VoxelCoord } from "std-contracts/components/VoxelCoordComponent.sol";

struct Coord {
  int32 x;
  int32 y;
}

enum BlockFace { // BlockFace = the face of a block. These enum values were taken from the bukkit codebase
  NORTH, // search for this in the bukkit codebase to find the block face: NORTH((byte)0, (byte)0, (byte)-1, BlockFace.EnumAxis.Z),
  SOUTH,
  EAST,
  WEST,
  TOP,
  BOTTOM
}

struct OpcBlock { // OpcBlock = OPCraft block. we cannot use the word "Block" since it's a reserved keyword
  VoxelCoord relativeCoord; // these coords are relative to the lower-south-west corner of the creation
  BlockFace blockFace;
  string blockType;
}