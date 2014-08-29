//Force-directed graph drawing
//This software is released under the MIT License. Copyright(c) 2014 Yui Arco Kita

Ganeza network;
void setup() {
  size(1000, 1000);
  network = new Ganeza("data.json");
  network.init();
  network.visualizer.method = "FORCE_DIRECTED";
  println(network.nodes.size());
}

void draw() {
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

