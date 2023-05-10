import { defineConfig } from "vite";
import path from "path";
import glob from "glob";

const config = {
  // server: {
  //   port: 4000,
  //   fs: {
  //     strict: false,
  //   },
  // },
  // optimizeDeps: {
  //   esbuildOptions: {
  //     target: "es2020",
  //   },
  //   exclude: ["@latticexyz/network"],
  //   include: [
  //     "proxy-deep",
  //     "ethers/lib/utils",
  //     "bn.js",
  //     "js-sha3",
  //     "hash.js",
  //     "bech32",
  //     "long",
  //     "protobufjs/minimal",
  //     "debug",
  //     "is-observable",
  //     "nice-grpc-web",
  //     "@improbable-eng/grpc-web",
  //   ],
  // },
  root: "src",
  build: {
    outDir: "./dist",
    rollupOptions: {
      input: glob.sync(path.resolve(__dirname, "src", "*.ts")),
    },
  },
};
console.log(config);
export default config;
