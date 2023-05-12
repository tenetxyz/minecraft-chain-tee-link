// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "./CreationBareComponent.sol"; // import everything, so the opcBlock type is also imported

uint256 constant ID = uint256(keccak256("component.Creation"));

// maps the creationId -> Creation
contract CreationComponent is CreationBareComponent {
    constructor(address world) CreationBareComponent(world, ID) {}

    function getCreationId(Creation memory creation) public returns (uint256) {
        return uint256(keccak256(abi.encode(creation.opcBlocks)));
    }
}
