//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita

Ganeza network;
void setup() {
  size(1000, 1000);
  network = new Ganeza("recipe_ethnic_american.json");
  network.visualizer.method = "FORCE_DIRECTED";
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

