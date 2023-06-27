import { setupMUDNetwork } from "@latticexyz/std-client";
import { createWorld } from "@latticexyz/recs";
import { SystemTypes } from "contracts/types/SystemTypes";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import {config, getNetworkConfig} from "./config";
import { defineActivatedCreationsComponent } from "./components/ActivatedCreationsComponent";
import {
  OpcBlockStruct,
  VoxelCoordStruct,
  VoxelCoordStructOutput
} from "contracts/types/ethers-contracts/RegisterCreationSystem";
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
components.ActivatedCreationsComponent.update$.subscribe(( res ) => {
  const ownerId = res.entity;
  const activatedCreations = res.value?.[0]?.value;
  if(!activatedCreations || activatedCreations.length === 0) {
    console.log("couldn't activate creations since we couldn't find the activated creationId")
    return;
  }
  const activatedCreationId:any = activatedCreations.at(-1); // right now, we are assuming tha tthe last element in the array is the one they just activated
  // TODO: get the blocks of the creation
  // @ts-ignore
  const creationBlocks = components.BlocksComponent.values[activatedCreationId];
  console.log("creation blocks");
  console.log(creationBlocks);
  for(const block of creationBlocks) {
    block.blockFace = blockFaceToString(block.blockFace);
  }
  console.log(creationBlocks);

  // console.log(value);
  // console.log(String(value?.[0]?.value));
  // TODO: for now, you can only activate each creation once
  const payload = {
    worldName: 'exampleWorld',
    ownerPlayerId: ownerId,
    blocks: creationBlocks,
    creationId: activatedCreationId,
  };

  // fetch(SIMULATOR_API_SERVER, {
  //   method: 'POST',
  //   headers: {
  //     'Content-Type': 'application/json'
  //   },
  //   body: JSON.stringify(payload)
  // }).then((res) => {
  //   console.log(`Simulated creation response=${res}`);
  // }).catch((err) => {
  //   console.log(`Cannot simulate creation err=${err}`)
  // });
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
  const creationId = res.entity;
  console.log(`registered creation WITH ID=${creationId}`);
});

// TODO: fix this so it's less sus
enum BlockFace { // the must be manually kept up-to-date with the solidity enum
  NORTH,
  SOUTH,
  EAST,
  WEST,
  UP,
  DOWN,
  NONE,
}

const blockFaceToString = (face:BlockFace):string => {
  switch(face) {
    case BlockFace.NORTH:
      return "NORTH";
    case BlockFace.SOUTH:
      return "SOUTH";
    case BlockFace.EAST:
      return "EAST";
    case BlockFace.WEST:
      return "WEST";
    case BlockFace.UP:
      return "UP";
    case BlockFace.DOWN:
      return "DOWN";
    case BlockFace.NONE:
      return "NONE";
  }
}
const createOpcBlock = (x:number,y:number,z:number, face:BlockFace, material:string):OpcBlockStruct => {
  return {
    relativeCoord: {
      x: x,
      y: y,
      z: z,
    } as VoxelCoordStruct,
    blockFace: face,
    material: material,
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
      createOpcBlock(0,0,0, BlockFace.NONE,"SLIME_BLOCK"),
      createOpcBlock(0,0,1, BlockFace.NORTH, "STICKY_PISTON"),
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

    (window as any).activateCreation = () => {
      systems["system.ActivateCreation"].executeTyped(
        "asdfasdf",
        {
          x:0,
          y:0,
          z:0,
        },
        { gasLimit: 100_000_000 }
      );
    }
  }
);
