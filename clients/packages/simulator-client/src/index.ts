import { setupMUDNetwork } from "@latticexyz/std-client";
import { createWorld } from "@latticexyz/recs";
import { SystemTypes } from "contracts/types/SystemTypes";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { config } from "./config";
import { defineActivatedCreationsComponent } from "./components/ActivatedCreationsComponent";

// The world contains references to all entities, all components and disposers.
const world = createWorld();
console.log("running");

// Components contain the application state.
// If a contractId is provided, MUD syncs the state with the corresponding
// component contract (in this case `CounterComponent.sol`)
const components = {
  ActivatedCreationsComponent: defineActivatedCreationsComponent(world),
};

const SIMULATOR_API_SERVER = "http://localhost:4500";

// Components expose a stream that triggers when the component is updated.
components.ActivatedCreationsComponent.update$.subscribe(({ value }) => {
  console.log("activated creations");
  console.log(value);
  fetch(SIMULATOR_API_SERVER).then((res) => {
    console.log(`Simulated creation response=${res}`);
  }).catch((err) => {
    console.log(`Cannot simulate creation err=${err}`)
  });
});
// we don't need faucets to drip cause we are just an observer

// This is where the magic happens
setupMUDNetwork<typeof components, SystemTypes>(config, world, components, SystemAbis).then(
  ({ startSync }) => {
    startSync();
  }
);
