import { setupMUDNetwork } from "@latticexyz/std-client";
import { createWorld } from "@latticexyz/recs";
import { SystemTypes } from "contracts/types/SystemTypes";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { config } from "./config";
import { definePositionComponent } from "./components/PositionComponent";

// The world contains references to all entities, all components and disposers.
const world = createWorld();
console.log("running");

// Components contain the application state.
// If a contractId is provided, MUD syncs the state with the corresponding
// component contract (in this case `CounterComponent.sol`)
// const components = {
//   Counter: defineNumberComponent(world, {
//     metadata: {
//       contractId: "component.Counter",
//     },
//   }),
// };
//
// // Components expose a stream that triggers when the component is updated.
// components.Counter.update$.subscribe(({ value }) => {
//   document.getElementById("counter")!.innerHTML = String(value?.[0]?.value);
// });

// Components contain the application state.
// If a contractId is provided, MUD syncs the state with the corresponding
// component contract (in this case `CounterComponent.sol`)
const components = {
  Position: definePositionComponent(world),
};

// Components expose a stream that triggers when the component is updated.
components.Position.update$.subscribe(({ value }) => {
  console.log("position update");
  for (const v of value) {
    console.log(v);
  }
});
// we don't need faucets to drip cause we are just an observer

// This is where the magic happens
setupMUDNetwork<typeof components, SystemTypes>(config, world, components, SystemAbis).then(
  ({ startSync, systems }) => {
    // After setting up the network, we can tell MUD to start the synchronization process.
    startSync();
    console.log("systems");
    console.log(systems);

    // Just for demonstration purposes: we create a global function that can be
    // called to invoke the Increment system contract. (See IncrementSystem.sol.)
    // (window as any).increment = () => systems["system.Increment"].executeTyped("0x00");
  }
);
