import { wrap } from "comlink";
import dot from "dot-wasm";
// import WASM_URL from "url:dot-wasm/dist/index.wasm";

export const worker = wrap(new Worker("./worker.js")).render;

export const main = dot(/*() => WASM_URL*/);
