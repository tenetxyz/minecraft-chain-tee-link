pragma solidity >=0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

library Utils {
    /**
     * @dev Converts a `int32` to its ASCII `string` decimal representation.
     */
    function int32ToString(int32 value) internal pure returns (string memory) {
        return Strings.toString(uint256(uint32(value)));
    }
}
