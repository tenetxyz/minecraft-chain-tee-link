// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { CreationOwnerComponent, ID as CreationOwnerComponentID } from "../components/CreationOwnerComponent.sol";
import { CreationBlocksComponent, ID as CreationBlocksComponentID } from "../components/CreationBlocksComponent.sol";
import { getClaimAtCoord } from "../systems/ClaimSystem.sol";
import { VoxelCoord } from "../types.sol";
import { AirID } from "../prototypes/Blocks.sol";

uint256 constant ID = uint256(keccak256("system.RegisterCreation"));

contract RegisterCreationSystem is System {
    constructor(IWorld _world, address _components) System(_world, _components) {}

    function execute(bytes memory arguments) public returns (bytes memory) {
        (address creationOwner, uint256[] memory opcBlocks) = abi.decode(arguments, (address, uint256[]));

        // we are not using msg.sender to register the creationOwner since it's coming from the mc server
        // This MC server is trusted to register creations on behalf of the player

        // Initialize components
        CreationOwnerComponent creationOwnerComponent = CreationOwnerComponent(getAddressById(components, CreationOwnerComponentID));
        CreationBlocksComponent creationBlocksComponent = CreationBlocksComponent(getAddressById(components, CreationBlocksComponentID));

        require(opcBlocks.length <= 200, "Your creation cannot exceed 100 blocks");

        uint256 creationId = uint256(keccak256(abi.encodePacked(opcBlocks))); // Note: we only hash the blocks, and not the owner, so we can see if this arrangement has been made before
        require(!creationOwnerComponent.has(creationId), string(abi.encodePacked("This creation has already been created by ", creationOwnerComponent.getValue(creationId) , ". This creation's id is " , creationId)));

        creationOwnerComponent.set(creationId, creationOwner);
        creationBlocksComponent.set(creationId, opcBlocks);
    }

    function executeTyped(address creationOwner, uint256[] memory opcBlocks) public returns (bytes memory) {
        return execute(abi.encode(creationOwner, opcBlocks));
    }
}
