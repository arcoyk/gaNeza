//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita
//http://bluedog.herokuapp.com/ganeza
import java.util.Map;
Ganeza network;
void setup() {
  size(500, 500);
  if (frame != null) {
    frame.setResizable(true);
  }
  network = new Ganeza("north_america_name.json");
  network.visualizer.c = color(0, 0, 0, 10);
  network.visualizer.method = "FORCE_DIRECTED";
  network.view.scale = 0.5;
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
    HashMap<Node, Node> short_map = network.analyzer.shortest_distance(start_node, goal_node);
    HashMap<Node, Integer> sub_nodes = new HashMap<Node, Integer>();
    for (Map.Entry e : short_map.entrySet()){
      Node from_node = (Node)e.getKey();
      Node to_node = (Node)e.getValue();
      Link link = new Link(from_node, to_node);
      
      sub_nodes.put(from_node, 1);
      sub_nodes.put(to_node, 3);
    }
    ArrayList<Node> sub_node_array = new ArrayList<Node>();
    for (Map.Entry e : sub_nodes.entrySet()){
      Node node = (Node)e.getKey();
      sub_node_array.add(node);
    }
    network.create_subnetwork(sub_node_array, "subnetwork", color(0, 0, 255, 300));
    
  }else if (key == 'n') {
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
