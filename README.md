# minecraft-chain-tee-link

This repo demonstrates how we can offload complex computations to an off-chain Trusted Execution Environment (TEE) and write the results back onto the chain… And we’re doing this verifiably!

### The Mission

One challenge of writing verifiable programs on-chain is that the limitations of the chain (contract size, language constraints, etc.) make it hard to write complex programs. One solution is to write these complex programs off-chain, run them in a ZKVM, then publish the proof of the computation back onto the chain to verify the computation. Unfortunately, ZKVMs are still in development and may not execute in a timely manner.

Another solution is to delegate the simulation environment to a TEE and write the result back onto the chain (alongside proof that it ran in a TEE - the TEE attestation). The TEE attestation proves that “the program that performed the computation was untampered”, similar to a ZK proof. TEEs can run faster than ZKVMs, and more importantly, can securely compute over multiple secrets at the price of reducing trust assumptions (we now need to trust Intel's SGX or Amazon's Nitro Enclaves).

### An Example in Detail

We placed a Minecraft server inside a TEE, which acts as our complex program. Our goal is to use this program to perform complex logic off-chain (redstone logic, crop growth, villager AI, etc.) and show that we can securely write the results of this simulation (after x seconds) back onto the chain.

Here is how a user will use our secure Minecraft simulator:
1) The user builds a creation (a cuboid selection of blocks) in OPCraft and registers the creation onto the chain.
  - To register a series of blocks as a creation, the user selects a volume of blocks and tells the chain: "This arrangement of blocks is my creation".
  - A simple creation to test is an automatic sugarcane farm.
2) An oracle listening to the chain will recognize this new creation and send the creation to the Minecraft server running in the TEE.
  - Note: the oracle needs to perform a TEE attestation to verify that the code in the TEE matches the code in this public repo.
  - Note: the oracle itself is a program that is also running in a TEE (This is what makes it the oracle).
3) Upon receiving the creation, the Minecraft server places it in the Minecraft world.
  - Note: We built an API server to receive external commands and spawn these creations.
4) Next, the Minecraft server will naturally simulate the farm (crop growth and harvesting).
5) After some time, a user can query the Minecraft server in the TEE to read how many crops were automatically harvested. These results are written back to the chain to document the results of the Minecraft simulation.

### Why use OPCraft?

We are using OPCraft as an interface for common knowledge. It tells users: "Alice built this creation, and we have shown via the Minecraft server in the TEE that it can produce 500 carrots per hour". By using OPCraft to declare creations on the chain, we can show that the entire process of securely offloading computations to the TEE and writing results back to the chain is end-to-end verifiable.

Note: This project is still a work in progress. Notably, we are still missing the logic to write the results of the computation back onto the chain.

This repo builds on top of our previous work of putting Minecraft in a TEE: https://github.com/tenetxyz/minecraft-tee. If you want to better understand how the attestation process works, try running that repo yourself!
