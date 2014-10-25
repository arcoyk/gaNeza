//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita

Ganeza network;
void setup() {
  size(1100, 700);
  network = new Ganeza("sample.json");
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
  if(key == 'c'){
    network.visualizer.method = "CIRCLE";
  }else if(key == 'f'){
    network.visualizer.method = "FORCE_DIRECTED";
  }else if(key == 's'){
    network.visualizer.attribute_hide = "Korean Sushi";
  }else if(key == 'n'){
    network.visualizer.attribute_hide = "normal";
  }else if(key == 'S'){
    save(""+year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+".png");
  }
}
