gaNeza
======
gaNeza is a network graph visualizer / analyzer
see also: http://bluedog.herokuapp.com/ganeza
![alt tag](http://bluedog.herokuapp.com/ganeza/forced.png)

HOWTO
======
Step1. Prepare a JSON file.

```
// sample.json
{
	"nodes": [
		{
			"node_name": "A",
			"link_to": ["B", "C"],
			"attributes": ["attr1", "attr2"]
		},

		{
			"node_name": "B",
			"link_to": ["A", "C"],
			"attributes": ["attr1"]
		},

		{
			"node_name": "C",
			"link_to": ["A", "B"],
			"attributes": ["attr2"]
		},

		{
			"node_name": "D",
			"link_to": ["A"],
			"attributes": ["attr2"]
		},

		{
			"node_name": "E",
			"link_to": [],
			"attributes": ["attr2"]
		},

	]
}
```
Step2. Initialize gaNeza instance and call visualizer.

```
// gaNeza.pde (note that gaNeza.pde and sample.json are in the same directory)
Ganeza ganeza = new Ganeza("sample.json");
void setup(){
	size(800, 800);
	ganeza.visualizer.method = "FORCE_DIRECTED";
}

void draw(){
	background(255);
	ganeza.show();
}
```

Step3. Run

![alt tag](http://bluedog.herokuapp.com/ganeza/simple.png)