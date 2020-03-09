import * as Render from "./render.js";

document.getElementById("input").value = `digraph graphname
{
    a -> b -> c;
    b -> d;
}`;

async function update() {
	let render = await (document.getElementById("useWorker").checked
		? Render.worker
		: Render.main);
	try {
		document.getElementById("output").innerHTML = await render(
			document.getElementById("input").value
		);
	} catch (e) {
		document.getElementById("output").textContent = e.message;
	}
}

update();

document.querySelector("button").onclick = update;
