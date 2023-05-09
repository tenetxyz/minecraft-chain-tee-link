"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.definePositionComponent = void 0;
const std_client_1 = require("@latticexyz/std-client");
function definePositionComponent(world) {
    return (0, std_client_1.defineVoxelCoordComponent)(world, {
        id: "Position",
        metadata: { contractId: "component.Position" },
    });
}
exports.definePositionComponent = definePositionComponent;
//# sourceMappingURL=PositionComponent.js.map