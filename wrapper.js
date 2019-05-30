const RawModule = require("./dist/dot-wasm.js");

module.exports = new Promise(res => {
	RawModule().then(Module => {
		const vizRenderFromString = Module.cwrap(
			"vizRenderFromString",
			"number",
			["string", "string", "string"]
		);
		const vizLastErrorMessage = Module.cwrap(
			"vizLastErrorMessage",
			"number",
			[]
		);
		const free = Module.cwrap("free", "number", ["number"]);

		function render(src) {
			const resultPointer = vizRenderFromString(src, "svg", "dot");
			const resultString = Module.UTF8ToString(resultPointer);
			free(resultPointer);

			const errorMessagePointer = vizLastErrorMessage();
			const errorMessageString = Module.UTF8ToString(errorMessagePointer);
			free(errorMessagePointer);

			if (errorMessageString) {
				throw new Error(errorMessageString);
			}

			return resultString;
		}

		res(render);
	});
});
