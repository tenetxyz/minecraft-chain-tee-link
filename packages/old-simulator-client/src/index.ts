import {
  // createActionSystem,
  // defineNumberComponent,
  setupMUDNetwork,
  // waitForActionCompletion,
} from "@latticexyz/std-client";
import { createWorld } from "@latticexyz/recs";
import { config } from "./config";
// import { SystemTypes } from "contracts/types/SystemTypes";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { definePositionComponent } from "./components/PositionComponent"; // this is a bit sus, we should refactor this out sometime

// The world contains references to all entities, all components and disposers.
const world = createWorld();

// Components contain the application state.
// If a contractId is provided, MUD syncs the state with the corresponding
// component contract (in this case `CounterComponent.sol`)
const components = {
  Position: definePositionComponent(world),
};

// Components expose a stream that triggers when the component is updated.
components.Position.update$.subscribe(({ value }) => {
  console.log(value);
});

// This is where the magic happens
setupMUDNetwork<typeof components, any>(config, world, components, SystemAbis).then(({ startSync, systems }) => {
  console.log("started simulator-client client");
  console.log(systems);
  // After setting up the network, we can tell MUD to start the synchronization process.
  startSync();

  // Just for demonstration purposes: we create a global function that can be
  // called to invoke the Increment system contract. (See IncrementSystem.sol.)
  // (window as any).increment = () => systems["system.Increment"].executeTyped("0x00");
});
