// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/BareComponent.sol";
import { VoxelCoord } from "../types.sol";
import { VoxelCoord, Creation, OpcBlock, ActivatedCreation } from "../types.sol";

uint256 constant ID = uint256(keccak256("component.ActivatedCreation"));

// maps ownerId -> list of activated creationIds at that coord
contract ActivatedCreationsComponent is BareComponent {
    constructor(address world) BareComponent(world, ID) {}

    function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
        keys = new string[](1);
        values = new LibTypes.SchemaValue[](1);

        keys[0] = "value";
        values[0] = LibTypes.SchemaValue.BYTES;
    }

    function set(uint256 entity, ActivatedCreation[] calldata value) public virtual {
        set(entity, abi.encode(value));
    }

    function getValue(uint256 entity) public view virtual returns (ActivatedCreation[] memory) {
        (ActivatedCreation[] memory activatedCreation) = abi.decode(getRawValue(entity), (ActivatedCreation[]));
        return activatedCreation;
    }

    function addCreation(uint256 entity, ActivatedCreation calldata creation) public virtual {
        ActivatedCreation[] memory oldCreations = getValue(entity);
        ActivatedCreation[] memory newCreations = new ActivatedCreation[](oldCreations.length + 1);
        for (uint256 i = 0; i < oldCreations.length; i++) {
            newCreations[i] = oldCreations[i];
        }
        newCreations[oldCreations.length] = creation;
        set(entity, abi.encode(newCreations));
    }

}