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

// updates return res, which is: {
//   entity: (the entity Id)
//   value: [new state, old state] (I think it's the old state)
//   component: (has a reference to all key-> value pairs of that component
// }
// where newState and old state is {
//   value: <value that is mapped to>
// }
// This is why if we just want to get the latest value, we use: String(value?.[0]?.value)
// we don't need faucets to drip cause we are just an observer
components.BlocksComponent.update$.subscribe(( res ) => {
  console.log("activated creations");
  const creationId = res.entity;
  const value = res.value?.[0]?.value;
  // console.log(value);
  // console.log(String(value?.[0]?.value));
  // TODO: for now, you can only activate each creation once
  const payload = {
    worldName: 'exampleWorld',
    ownerPlayerId: '12345',
    blocks: [
      { blockMaterial: 'stone', x: 1, y: 1, z: 1 },
      { blockMaterial: 'chest', x: -1, y: -1, z: -1 }
    ],
    creationId: creationId,
  };

  fetch(SIMULATOR_API_SERVER, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  }).then((res) => {
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
    // why is systems an empty object here? It just takes a bit of time to initialize
    startSync();

    const blocks = [
      createOpcBlock(0,0,0, 0,5),
      createOpcBlock(0,0,1, 0,5),
    ];
    // debugger
    // interesting, the systems object is not available until later

    (window as any).submitCreation = () => {
      systems["system.RegisterCreation"].executeTyped(
        blocks,{ gasLimit: 100_000_000 }
      ).then(res => {
        // this res is a confirmation the contract was sent
        // console.log(`creationId`);
        // console.log(res);
        res.wait(3).then((receipt) => {
          // this is the actual result of the contract
          // console.log("receipt");
          // console.log(receipt);
        }).catch(err => {
          // console.log("error!");
          // console.log(err);
        }) ;
      });
    }

    // (window as any).activateCreation = () => {
    //   systems["system.ActivateCreation"].executeTyped(
    //     blocks,{ gasLimit: 100_000_000 }
    //   );
    // }
  }
);
