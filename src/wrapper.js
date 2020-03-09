module.exports = RawModule => locateFile => {
	return new Promise(res => {
		RawModule({ locateFile }).then(Module => {
			const graphvizRenderFromString = Module.cwrap(
				"graphvizRenderFromString",
				"number",
				["string", "string", "string"]
			);
			const graphvizLastErrorMessage = Module.cwrap(
				"graphvizLastErrorMessage",
				"number",
				[]
			);
			const freeStringRenderString = Module.cwrap(
				"freeStringRenderString",
				null,
				["number"]
			);

			function render(src) {
				const resultPointer = graphvizRenderFromString(
					src,
					"svg",
					"dot"
				);
				const resultString = Module.UTF8ToString(resultPointer);
				freeStringRenderString(resultPointer);

				const errorMessagePointer = graphvizLastErrorMessage();
				if (errorMessagePointer) {
					const errorMessageString = Module.UTF8ToString(
						errorMessagePointer
					);
					throw new Error(errorMessageString);
				}

				return resultString;
			}

			res(render);
		});
	});
};
