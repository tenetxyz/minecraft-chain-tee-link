// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import { VoxelCoord } from "std-contracts/components/VoxelCoordComponent.sol";

struct Coord {
  int32 x;
  int32 y;
}

enum BlockFace { // BlockFace = the face of a block. These enum values were taken from the bukkit codebase
  NORTH,
  SOUTH,
  EAST,
  WEST,
  UP,
  DOWN
}

struct OpcBlock { // OpcBlock = OPCraft block. we cannot use the word "Block" since it's a reserved keyword
  VoxelCoord relativeCoord; // these coords are relative to the lower-south-west corner of the creation
  BlockFace blockFace;
  string material;
}