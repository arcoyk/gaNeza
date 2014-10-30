//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita
//http://bluedog.herokuapp.com/ganeza

Ganeza network;
void setup() {
  size(1100, 700);
  network = new Ganeza("north_america_name.json");
  network.visualizer.method = "FORCE_DIRECTED";
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
  }else if (key == 'a') {
    network.visualizer.attribute_hide = "country1";
  }else if (key == 'n') {
    network.visualizer.attribute_hide = "normal";
  }else if (key == 'h') {
    network.visualizer.highlight("country3", color(10, 200, 10));
  }else if (key == 'S') {
    save(""+year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+".png");
  }
}

void discription(){
  println("PRESS\nc->CIRCLE\nf->FORCE_DIRECTED\na->limit node\nn->unlimit node\nS->save image at "+sketchPath(""));
}
