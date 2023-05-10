// import {path} from 'path';
import path from 'path';
const __dirname = path.dirname(new URL(import.meta.url).pathname);

const config = {
  mode: 'development',
  module: {
    rules: [
      // {
      //   exclude: /(node_modules)/,
      // },
      {
        test: /\.js$/,
        resolve: {
          fullySpecified: false, // disable the behaviour
        },
        use: {
          loader: "esbuild-loader"
        }
      },
    ]
  },
  resolve: {
    extensions: [".ts"]
  },
  entry: {
    onboarding: path.resolve(__dirname, "src/index.ts"),
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    // I think it's [name].js since we compile multiple entry points using this config (onboarding AND app)
    filename: "[name].js",
    sourceMapFilename: "[name].js.map",
  },
};
export default config;