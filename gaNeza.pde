//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita
//http://bluedog.herokuapp.com/ganeza
import java.util.Map;

View view;
Ganeza network;
BoxImage input_boximage;
BoxImage output_boximage;
BoxImage answer_boximage;
int layer_num = 20;
int node_num = 16;
boolean ans_flag;
ArrayList<Node> input_binded_nodes;
void setup() {
  size(800, 800);
  frame.setResizable(true);
  network = new Ganeza();
  // network initialization
  network.init_nn(layer_num, node_num);
  network.visualizer.c = color(0, 0, 0, 50);
  network.visualizer.method = "FORCE_DIRECTED";
  view = new View();
  view.scale = 0.5;
  discription();
  // boximage initialization
  input_boximage = new BoxImage("TRIANGLE", "IN", 4, 4);
  output_boximage = new BoxImage("TRIANGLE", "OUT", 4, 4);
  output_boximage.flip("VERTICAL");
  answer_boximage = new BoxImage("BLANK", "ANS", 4, 4);
  // bind input output to nn
  int last_start = (layer_num - 1) * node_num;
  input_binded_nodes = bind_to_boximage(input_boximage, 0, node_num);
  bind_to_boximage(output_boximage, last_start, node_num);
  ans_flag = false;
}

void draw() {
  background(255);
  // viewing
  translate(width / 2 - width * view.scale / 2, height / 2 - height * view.scale / 2);
  scale(view.scale);
  translate(view.view_point.x, view.view_point.y);
  // learning
  input_boximage.show(new PVector(100, 100));
  output_boximage.show(new PVector(700, 100));
  answer_boximage.show(new PVector(100, 700));
  network.show();
  network.propagate();
  network.attenuation(2);
  network.random_rewired();
  random_ans_clear();
  fire();
}

void fire() {
  for (Node node : input_binded_nodes) {
    if (node.box != null && node.box.value == 0) {
      node.value = 1;
    }
  }
}

void random_ans_clear() {
  for (Box box : answer_boximage.boxes) {
    if (random(1) < 0.3) {
      continue;
    }
    box.value = 255;
  }
}

ArrayList<Node> bind_to_boximage(BoxImage boximage, int start, int num) {
  ArrayList<Node> binded_nodes = new ArrayList<Node>();
  for (int i = 0; i < num; i++) {
    Node node = network.nodes.get(start + i);
    node.bind(boximage.boxes.get(i));
    binded_nodes.add(node);
  }
  return binded_nodes;
}

void toggle_ans_and_out() {
  int last_start = (layer_num - 1) * node_num;
  if (ans_flag) {
    bind_to_boximage(output_boximage, last_start, node_num);
  } else {
    bind_to_boximage(answer_boximage, last_start, node_num);
  }
  ans_flag = !ans_flag;
}

void mousePressed() {
  view.mousePressed();
}

void mouseDragged() {
  view.mouseDragged();
}

void mouseWheel(MouseEvent event){
  view.mouseWheel(event);
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
    network.random_rewired();
  }else if (key == 'a') {
    toggle_ans_and_out();
  }
}

void discription() {
  println("PRESS\nc->CIRCLE\nf->FORCE_DIRECTED\nS->save image at "+sketchPath(""));
}