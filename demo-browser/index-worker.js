import { wrap } from "comlink";

document.getElementById("input").value = `digraph graphname
{
    a -> b -> c;
    b -> d;
}`;

(async () => {
	const f = await wrap(new Worker("./worker.js"));
	console.log(f);
	async function update() {
		try {
			document.getElementById("output").innerHTML = await f.render(
				document.getElementById("input").value
			);
		} catch (e) {
			document.getElementById("output").textContent = e.message;
		}
	}
	update();

	document.querySelector("button").onclick = update;
})();
