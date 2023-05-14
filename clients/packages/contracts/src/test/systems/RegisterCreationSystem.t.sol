// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

import { MudTest } from "std-contracts/test/MudTest.t.sol";
import { Deploy } from "../Deploy.sol";
import { RegisterCreationSystem, ID as RegisterCreationSystemID } from "../../systems/RegisterCreationSystem.sol";
import { BlocksComponent, ID as BlocksComponentID} from "../../components/BlocksComponent.sol";
import { BlocksComponent, ID as BlocksComponentID} from "../../components/BlocksComponent.sol";
import { VoxelCoord, BlockFace, OpcBlock } from "../../types.sol";
import { getAddressById } from "solecs/utils.sol";

contract RegisterCreationTest is MudTest {
    constructor() MudTest(new Deploy()) {}

    function testRegisterCreation() public {

        vm.startPrank(alice);
        BlocksComponent blocksComponent = BlocksComponent(getAddressById(components, BlocksComponentID));
        RegisterCreationSystem registerCreationSystem = RegisterCreationSystem(system(RegisterCreationSystemID));

        VoxelCoord memory relativeCoord = VoxelCoord(getRandomNumber(), getRandomNumber(), getRandomNumber());
        BlockFace blockFace = BlockFace.NORTH;
        OpcBlock[] memory opcBlocks = new OpcBlock[](1);
        opcBlocks[0] = OpcBlock(relativeCoord, blockFace, 2);
        uint256 creationEntityId = abi.decode(registerCreationSystem.executeTyped(opcBlocks), (uint256));

        assertEq(blocksComponent.getValue(creationEntityId).length, 1);
        vm.stopPrank();
    }

    function getRandomNumber() public view returns (int32) {
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 10000 + 1;
        return int32(int256(randomNumber));
    }
}
