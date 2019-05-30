const render = require("./wrapper.js");

render.then(function(f) {
	console.log(
		f(
			` digraph graphname
 {
     a -> b -> c;
     b -> d;
 }`
		)
	);
});
