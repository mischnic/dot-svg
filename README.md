# dot-svg

**[Demo](https://dot-wasm.now.sh/)**

Render `.dot` Graphs into SVGs right in your browser (or in node without any native module). 

## Usage

The package exports a promise that resolves to a `dotToSVG` function. This is necessary because this function can only be called after the WASM module was loaded.

```js
const render = require("@mischnic/dot-svg");

render.then(function(dotToSVG) {
	try {
		const svg = dotToSVG(document.querySelector("textarea").value);
	} catch(e){
		console.error(e);
	}
	// ...
});
```

For examples, see [this node example](./demo-node.js) or [this more complete browser example](./demo-browser), which is also hosted as a demo at https://dot-wasm.now.sh/

<br>

For the most part this is a reduced version fo the unmaintained https://github.com/mdaines/viz.js .