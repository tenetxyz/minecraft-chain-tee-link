import { setupMUDNetwork } from "@latticexyz/std-client";
import { createWorld } from "@latticexyz/recs";
import { SystemTypes } from "contracts/types/SystemTypes";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { config } from "./config";
import { defineActivatedCreationsComponent } from "./components/ActivatedCreationsComponent";
import {OpcBlockStruct, VoxelCoordStruct} from "contracts/types/ethers-contracts/RegisterCreationSystem";

// The world contains references to all entities, all components and disposers.
const world = createWorld();
console.log("running");

// Components contain the application state.
// If a contractId is provided, MUD syncs the state with the corresponding
// component contract (in this case `CounterComponent.sol`)
const components = {
  ActivatedCreationsComponent: defineActivatedCreationsComponent(world),
  RegisterCreationsComponent: defineActivatedCreationsComponent(world),
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
components.RegisterCreationComponent.update$.subscribe(({ value }) => {
  console.log("activated creations");
  console.log(value);
  fetch(SIMULATOR_API_SERVER).then((res) => {
    console.log(`Simulated creation response=${res}`);
  }).catch((err) => {
    console.log(`Cannot simulate creation err=${err}`)
  });
});

const createOpcBlock = (x:number,y:number,z:number,face:number,type:number):OpcBlockStruct => {
  return {
    relativeCoord: {
      x: x,
      y: y,
      z: z,
    } as VoxelCoordStruct,
    blockFace: face,
    blockType: type,
  } as OpcBlockStruct;
}

// This is where the magic happens
setupMUDNetwork<typeof components, SystemTypes>(config, world, components, SystemAbis).then(
  ({ startSync, systems }) => {
    startSync();

    const blocks = [
      createOpcBlock(0,0,0, 0,5),
      createOpcBlock(0,0,0, 0,6),
      createOpcBlock(0,0,0, 0,9),
    ];

    (window as any).submitCreation = () => systems["system.RegisterCreation"].executeTyped(
       "me",
      blocks,
    );
  }
);
