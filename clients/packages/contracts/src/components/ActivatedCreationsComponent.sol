// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/Uint256ArrayBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.ActivatedCreation"));

// maps ownerId -> list of activated creationIds
// activated creations are just entities with a position and a creationId
contract ActivatedCreationsComponent is Uint256ArrayBareComponent {
    constructor(address world) Uint256ArrayBareComponent(world, ID) {}

    function addCreation(uint256 ownerEntityId, uint256 creationEntityId) public virtual {
        uint256[] memory oldCreations = getValue(ownerEntityId);
        uint256[] memory newCreations = new uint256[](oldCreations.length + 1);
        for (uint256 i = 0; i < oldCreations.length; i++) {
            newCreations[i] = oldCreations[i];
        }
        newCreations[oldCreations.length] = creationEntityId;
        set(ownerEntityId, abi.encode(newCreations));
    }
}