// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "solecs/BareComponent.sol";

import { Creation } from "../types.sol";

uint256 constant ID = uint256(keccak256("component.BlocksComponent"));

// maps the creationId -> Creation
contract BlocksComponent is Uint256ArrayBareComponent {
    constructor(address world) BareComponent(world, ID) {}

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
