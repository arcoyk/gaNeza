gaNeza
======
gaNeza is a network graph visualizer / analyzer
see also: http://bluedog.herokuapp.com/
![alt tag](http://bluedog.herokuapp.com/acd.png)

HOWTO
======
Step1. Prepare a JSON file.

/* sample.json */
{
	"nodes": [
		{
			"node_name": "A",
			"link_to": ["B", C"],
			"attributes": ["attr1", "attr2"]
		},

		{
			"node_name": "B",
			"link_to": ["C"],
			"attributes": ["attr1"]
		},

		{
			"node_name": "C",
			"link_to": [],
			"attributes": ["attr2"]
		}
	]
}

Step2. Initialize gaNeza instance and call visualizer.

/* gaNeza.pde (note that gaNeza.pde and sample.json are in the same directory) */

Ganeza ganeza = new Ganeza("sample.json");
void setup(){
	size(800, 800);
	ganeza.visualizer.method = "FORCE_DIRECTED";
}

void draw(){
	background(255);
	ganeza.show();
}