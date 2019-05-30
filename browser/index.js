const render = require("..");

render.then(function(f) {
	function update() {
		document.getElementById("main").innerHTML = f(
			document.querySelector("textarea").value
		);
	}
	update();

	document.querySelector("button").onclick = update;
});
