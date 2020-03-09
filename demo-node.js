const input = `digraph graphname
 {
     a -> b -> c;
     b -> d;
 }`;

require("./")().then(function(render) {
	console.log(render(input));
});
