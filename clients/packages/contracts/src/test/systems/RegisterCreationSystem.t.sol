// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

import { MudTest } from "std-contracts/test/MudTest.t.sol";
import { Deploy } from "../Deploy.sol";
import { RegisterCreationSystem, ID as RegisterCreationSystemID } from "../../systems/RegisterCreationSystem.sol";
import { BlocksComponent, ID as BlocksComponentID} from "../../components/BlocksComponent.sol";
import { BlocksComponent, ID as BlocksComponentID} from "../../components/BlocksComponent.sol";
import { VoxelCoord, BlockFace, OpcBlock } from "../../types.sol";
import { getAddressById } from "solecs/utils.sol";

contract MineSystemTest is MudTest {
    constructor() MudTest(new Deploy()) {}

    function testRegisterCreation() public {

        vm.startPrank(alice);
        BlocksComponent blocksComponent = BlocksComponent(getAddressById(components, BlocksComponentID));
        RegisterCreationSystem registerCreationSystem = RegisterCreationSystem(system(RegisterCreationSystemID));

        VoxelCoord memory relativeCoord = VoxelCoord(0, 0, 0);
        BlockFace blockFace = BlockFace.NORTH;
        OpcBlock[] memory opcBlocks = new OpcBlock[](1);
        opcBlocks[0] = OpcBlock(relativeCoord, blockFace, 2);
        uint256 creationEntityId = abi.decode(registerCreationSystem.executeTyped(alice, opcBlocks), (uint256));

        assertEq(blocksComponent.getValue(creationEntityId).length, 1);
        vm.stopPrank();
    }
}
