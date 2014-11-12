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
    for (int m = 0; m < 100; m++) {
      for (int i = 0; i < 6; i++) {
        Node node = network.nodes.get((int)random(network.nodes.size()));
        print(node.name + ", ");
        sample_ings.add(node);
      }
      float average = average_distance(sample_ings);
      network.create_subnetwork(sample_ings, "sample", color(0, map(average, 0, 5, 0, 255), 255, 255));
      println(average);
    }
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

float average_distance(ArrayList<Node> nodes){
  ArrayList<Node> path = new ArrayList<Node>();
  float average_distance = 0;
  float long_distance = 100000;
  int cnt = 0;
  for (int i = 0; i < nodes.size() - 1; i++) {
    for (int m = i + 1; m < nodes.size(); m++) {
      Node node1 = nodes.get(i);
      Node node2 = nodes.get(m);
      path = network.analyzer.shortest_distance(node1, node2);
      if (path.size() < 2) {
        average_distance += long_distance;
      }
      float distance_in_path = 0;
      for (int k = 0; k < path.size() - 1; k++) {
        Node to_node = path.get(k);
        Node from_node = path.get(k + 1);
        for (Link link : from_node.links) {
          if (link.to_node == to_node) {
            distance_in_path += link.weight;
            break;
          }
        }
      }
      average_distance += distance_in_path;
      cnt++;
    }
  }
  return average_distance / cnt;
}
