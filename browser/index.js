const render = require("..");

document.getElementById("input").value = `digraph graphname
{
    a -> b -> c;
    b -> d;
}`;

render.then(function(f) {
	function update() {
		try {
			document.getElementById("output").innerHTML = f(
				document.getElementById("input").value
			);
		} catch (e) {
			document.getElementById("output").textContent = e.message;
		}
	}
	update();

	document.querySelector("button").onclick = update;
});
