import { SetupContractConfig } from "@latticexyz/std-client";
// import { Wallet } from "ethers";
const params = new URLSearchParams(window.location.search);

//http://localhost:3000?chainId=31337&worldAddress=0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512&rpc=http://localhost:8545&wsRpc=ws://localhost:8545&initialBlockNumber=46&dev=true&snapshot=&stream=&relay=&faucet=&burnerWalletPrivateKey=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
export const config: SetupContractConfig = {
  clock: {
    period: 1000,
    initialTime: 0,
    syncInterval: 5000,
  },
  provider: {
    jsonRpcUrl: params.get("rpc") ?? "http://localhost:8545",
    wsRpcUrl: params.get("wsRpc") ?? "ws://localhost:8545",
    chainId: Number(params.get("chainId")) || 31337,
  },
  //Wallet.createRandom().privateKey,
  privateKey: "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
  chainId: Number(params.get("chainId")) || 31337,
  snapshotServiceUrl: params.get("snapshot") ?? undefined,
  initialBlockNumber: Number(params.get("initialBlockNumber")) || 0,
  worldAddress: "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",//params.get("worldAddress")!,
  devMode: params.get("dev") === "true",
};
export type GameConfig = {
  worldAddress: string;
  privateKey: string;
  chainId: number;
  jsonRpc: string;
  wsRpc?: string;
  snapshotUrl?: string;
  streamServiceUrl?: string;
  relayServiceUrl?: string;
  faucetServiceUrl?: string;
  devMode: boolean;
  initialBlockNumber: number;
  blockTime: number;
  blockExplorer?: string;
};

export const getNetworkConfig: (networkConfig: GameConfig) => SetupContractConfig = (config) => ({
  clock: {
    period: config.blockTime,
    initialTime: 0,
    syncInterval: 60_000,
  },
  provider: {
    chainId: config.chainId,
    jsonRpcUrl: config.jsonRpc,
    wsRpcUrl: config.wsRpc,
    options: {
      batch: false,
      pollingInterval: 1000,
    },
  },
  privateKey: config.privateKey,
  chainId: config.chainId,
  snapshotServiceUrl: config.snapshotUrl,
  streamServiceUrl: config.streamServiceUrl,
  relayServiceUrl: config.relayServiceUrl,
  initialBlockNumber: config.initialBlockNumber,
  worldAddress: config.worldAddress,
  devMode: config.devMode,
  blockExplorer: config.blockExplorer,
  cacheAgeThreshold: 60 * 60, // Invalidate cache after 1h
  cacheInterval: 120, // Store cache every 2 minutes
  limitEventsPerSecond: 100_000,
  snapshotNumChunks: 20,
});
