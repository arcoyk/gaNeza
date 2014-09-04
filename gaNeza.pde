//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita

Ganeza network;
void setup() {
  size(1000, 1000);
  network = new Ganeza("recipe_ethnic_american.json");
  network.visualizer.method = "FORCE_DIRECTED";
}

ArrayList<Node> nodes;
float max_point = 0;
void draw() {
  //analysis
  nodes = new ArrayList<Node>();
  for(int i=0; i<(int)random(5, network.nodes.size()); i++){
    nodes.add(network.getRandomNode());
  }
  network.flushAttribute("selecting");
  network.addAttribute(nodes, "selecting");
  int link_count = network.analyzer.link_count(nodes);
  float link_distribution = network.analyzer.link_distribution(nodes);
  float link_count_per_node = link_count/nodes.size();
  float point = link_distribution/link_count_per_node;
  if(point > max_point){
    max_point = point;
    network.flushAttribute("stable");
    network.addAttribute(nodes, "stable");
  }
  background(255);
  network.show();
}

void mousePressed(){
  network.mousePressed();
}

void mouseDragged(){
  network.mouseDragged();
}

void keyPressed(){
  network.keyPressed();
}

