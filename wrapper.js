const Module = require("./dist/dot-wasm.js");

function render(instance, src) {
	var resultPointer = instance["ccall"](
		"vizRenderFromString",
		"number",
		["string", "string", "string"],
		[src, "svg", "dot"]
	);
	var resultString = instance["UTF8ToString"](resultPointer);
	instance["ccall"]("free", "number", ["number"], [resultPointer]);

	var errorMessagePointer = instance["ccall"](
		"vizLastErrorMessage",
		"number",
		[],
		[]
	);
	var errorMessageString = instance["UTF8ToString"](errorMessagePointer);
	instance["ccall"]("free", "number", ["number"], [errorMessagePointer]);

	if (errorMessageString != "") {
		throw new Error(errorMessageString);
	}

	return resultString;
}

module.exports = new Promise(res => {
	Module().then(x => {
		res(src => render(x, src));
	});
});
