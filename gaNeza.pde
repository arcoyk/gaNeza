//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita
//http://bluedog.herokuapp.com/ganeza

Ganeza network;
void setup() {
  size(1100, 700);
  if (frame != null) {
    frame.setResizable(true);
  }
  network = new Ganeza("north_america_name.json");
  network.visualizer.c = color(100, 0, 100, 50);
  network.visualizer.method = "FORCE_DIRECTED";
  discription();
}

Link getLink(Node node1, Node node2) {
  for (Link link : node1.links) {
    if (link.to_node == node2) {
      return link;
    }
  }
  return null;
}

void draw() {
  background(255);
  network.show();
}

void mousePressed() {
  network.mousePressed();
}

void mouseDragged() {
  network.mouseDragged();
}

void mouseWheel(MouseEvent event){
  network.mouseWheel(event);
}

void keyPressed() {
  if (key == 'c') {
    network.visualizer.method = "CIRCLE";
  }else if (key == 'f') {
    network.visualizer.method = "FORCE_DIRECTED";
  }else if (key == 'l') {
    network.visualizer.method = "LINEUP";
  }else if (key == 'S') {
    save(""+year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+".png");
  }else if (key == 's') {
    Node start_node = network.nodes.get((int)random(network.nodes.size()-1));
    Node goal_node = network.nodes.get((int)random(network.nodes.size()-1));
    println(start_node.name);
    println(goal_node.name);
    float shortest_distance = network.analyzer.shortest_distance(start_node, goal_node);
    println(shortest_distance);
  }else if (key == 'd') {
    network.subnetwork_list.clear();
    ArrayList<Node> random_nodes = new ArrayList<Node>();
    for (int i = 0; i < 10; i++) {
      random_nodes.add(network.nodes.get((int)random(network.nodes.size())));
    }
    network.create_subnetwork(random_nodes, "random", color(100, 0, 0, 255));
  }
}

void discription() {
  println("PRESS\nc->CIRCLE\nf->FORCE_DIRECTED\nS->save image at "+sketchPath(""));
}

void mouse_select() {
  for (Node node : network.nodes) {
    float distance = sqrt(pow(mouseX - node.p.x, 2) + pow(mouseY - node.p.y, 2));
    if (distance < 10.0) {
      break;
    }
  }
}
