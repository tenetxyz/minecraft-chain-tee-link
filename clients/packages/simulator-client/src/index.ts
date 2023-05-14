import { setupMUDNetwork } from "@latticexyz/std-client";
import { createWorld } from "@latticexyz/recs";
import { SystemTypes } from "contracts/types/SystemTypes";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import {config, getNetworkConfig} from "./config";
import { defineActivatedCreationsComponent } from "./components/ActivatedCreationsComponent";
import {OpcBlockStruct, VoxelCoordStruct} from "contracts/types/ethers-contracts/RegisterCreationSystem";
import {defineBlocksComponent} from "./components/BlocksComponent";

// The world contains references to all entities, all components and disposers.
const world = createWorld();
console.log("running");

// Components contain the application state.
// If a contractId is provided, MUD syncs the state with the corresponding
// component contract (in this case `CounterComponent.sol`)
const components = {
  ActivatedCreationsComponent: defineActivatedCreationsComponent(world),
  BlocksComponent: defineBlocksComponent(world),
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
components.BlocksComponent.update$.subscribe(({ value }) => {
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
// setupMUDNetwork<typeof components, SystemTypes>(config, world, components, SystemAbis).then(
setupMUDNetwork<typeof components, SystemTypes>(config, world, components, SystemAbis, {
    initialGasPrice: 2_000_000,
  }).then(

  ({ startSync, systems }) => {
    // why is systems an empty object here?
    startSync();

    const blocks = [
      createOpcBlock(0,0,0, 0,5),
      createOpcBlock(0,1,0, 0,6),
      createOpcBlock(0,0,3, 0,10),
    ];
    // debugger
    // interesting, the systems object is not available until later

    (window as any).submitCreation = () => {
      console.log("register")
      console.log(systems["system.RegisterCreation"]);
      systems["system.RegisterCreation"].executeTyped(
        blocks,{ gasLimit: 100_000_000 }
      );
    }
  }
);
