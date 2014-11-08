//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita
//http://bluedog.herokuapp.com/ganeza

import java.util.TreeSet;

Ganeza network;
void setup() {
  size(1100, 700);
  network = new Ganeza("north_america_name.json");
  network.visualizer.c = color(0, 100, 0, 100);
  network.visualizer.method = "FORCE_DIRECTED";
  discription();
}

Link getLink(Node node1, Node node2){
  for(Link link : node1.links){
    if(link.to_node == node2){
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

ArrayList<Node> path_nodes = new ArrayList<Node>();
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
    Node start_node = network.get_node("White");
    Node goal_node = network.get_node("Thompson");
    path_nodes = network.analyzer.shortest_path(start_node, goal_node);
    int cnt = 0;
    println(path_nodes.size());
    for(int i = 0; i < path_nodes.size() - 1; i++){
      Node node = path_nodes.get(i);
      println(node.name);
      Link link = getLink(path_nodes.get(i), path_nodes.get(i + 1));
      println(link.from_node.name + " -> " + link.to_node.name + " " + link.weight);
      cnt += link.weight;  
    }
    println("sum : " + cnt);
  }
}

void discription(){
  println("PRESS\nc->CIRCLE\nf->FORCE_DIRECTED\nS->save image at "+sketchPath(""));
}

void mouse_select(){
  for(Node node : network.nodes){
    float distance = sqrt(pow(mouseX - node.p.x, 2) + pow(mouseY - node.p.y, 2));
    if(distance < 10.0){
      break;
    }
  }
}
