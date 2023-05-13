// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "std-contracts/components/Uint256BareComponent.sol";
import { addressToEntity } from "solecs/utils.sol";

uint256 constant ID = uint256(keccak256("component.ResourceCount"));

contract ResourceCountComponent is Uint256BareComponent {
    constructor(address world) Uint256BareComponent(world, ID) {}

    function getResourceEntityId(address player, uint256 resourceType) private view returns (uint256) {
        return uint256(keccak256(abi.encode(addressToEntity(player), resourceType)));
    }

    function updateResourceCount(address player, uint256 resourceType, uint256 amountChange) public virtual {
        uint256 entityId = getResourceEntityId(player, resourceType);
        uint256 currentAmount = getValue(entityId);
        set(entityId, currentAmount + amountChange);
    }
}
