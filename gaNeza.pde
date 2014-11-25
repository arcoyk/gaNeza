//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita
//http://bluedog.herokuapp.com/ganeza
import java.util.Map;

Ganeza network;
void setup() {
  size(800, 800);
  if (frame != null) {
    frame.setResizable(true);
  }
  network = new Ganeza("recipe_ethnic_american.json");
  network.visualizer.c = color(0, 0, 0, 50);
  network.visualizer.method = "FORCE_DIRECTED";
  network.view.scale = 0.5;
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
    ArrayList<Node> sample_ings = new ArrayList<Node>();
    for (int i = 0; i < 6; i++) {
      Node node = network.nodes.get((int)random(network.nodes.size()));
      sample_ings.add(node);
    }
    network.create_subnetwork(sample_ings, "sample", color(0, 100, 100, 255));
    Profile profile = network.analyzer.get_profile(sample_ings);
    for (Node node : sample_ings) {
      print(node.name + ",");
    }
    print(profile.average_distance + ",");
    print(profile.standard_deviation_distance);
    println();
  }else if (key == 'n') {
  }
}


