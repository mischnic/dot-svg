import dot from "dot-wasm";
import WASM_URL from "url:dot-wasm/dist/index.wasm";

document.getElementById("input").value = `digraph graphname
{
    a -> b -> c;
    b -> d;
}`;

dot(() => WASM_URL).then(function(f) {
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
