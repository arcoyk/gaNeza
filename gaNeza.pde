//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita
//http://bluedog.herokuapp.com/ganeza
import java.util.Map;

Ganeza network;
void setup() {
  size(800, 800);
  frame.setResizable(true);
  network = new Ganeza("north_america_name.json");
  network.visualizer.c = color(0, 0, 0, 50);
  network.visualizer.method = "FORCE_DIRECTED";
  network.view.scale = 0.5;
  discription();
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
    ArrayList<Node> path = network.analyzer.shortest_distance(start_node, goal_node);
    network.create_subnetwork(path, "path", color(0, 200, 200, 255));
  }else if (key == 'n') {
  }
}

void discription() {
  println("PRESS\nc->CIRCLE\nf->FORCE_DIRECTED\nS->save image at "+sketchPath(""));
}
