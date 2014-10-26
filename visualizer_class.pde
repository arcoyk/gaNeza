class Visualizer{
  int C = 130000;
  int J = 1;
  int L = 50;
  int M = 10;
  int f_limit = 10;
  int min_dist = 30;
  int size_limit = 1500;
  ArrayList<Node> nodes;
  String method = "FORCE_DIRECTED";
  String attribute_hide = "normal";
  color wine_red = color(255, 100, 50);
  color deep_blue = color(20, 20, 255);
  color white = color(255, 255, 255);
  color gray = color(200, 200, 200);
  color black = color(0, 0, 0);
  Visualizer(ArrayList<Node> in_nodes) {
    nodes = in_nodes;
  }
  
  void visualize(){
    if (method == "FORCE_DIRECTED") {
      force_directed();
    }else if (method == "CIRCLE") {
      circle();
    }
    show();
  }
  
  void show(){
    for (Node node : nodes) {
      if (!node.findAttribute(attribute_hide)) {
        continue;
      }
      for (Link link : node.links) {
        if (!link.to_node.findAttribute(attribute_hide)) {
          continue;
        }
        stroke_color(gray);
        line(node.p.x, node.p.y, link.to_node.p.x, link.to_node.p.y);
        stroke_color(black);
      }
    }
    for (Node node : nodes) {
      if (!node.findAttribute(attribute_hide)) {
        continue;
      }
      stroke_color(black);
      fill_color(black);
      textSize(20);
      ellipse(node.p.x, node.p.y, 10, 10);
      text(node.name, node.p.x, node.p.y - 5);
      stroke_color(white);
      fill_color(white);
    }
  }
  
  void circle(){
    int cnt = 0;
    for (Node node : nodes) {
      if (!node.findAttribute(attribute_hide)) {
        continue;
      }
      cnt++;
    }
    float circle_rad = min_dist / (2 * sin(PI / cnt));
    float interval = 2 * PI / cnt;
    PVector center = new PVector(width/2, height/2);
    cnt = 0;
    for (Node node : nodes) {
      if(!node.findAttribute(attribute_hide)){
        continue;
      }
      cnt++;
      node.p.x = center.x + circle_rad * cos(interval * cnt);
      node.p.y = center.y + circle_rad * sin(interval * cnt);
    }
  }
  
  void force_directed() {
    for (Node node1 : nodes) {
      if(!node1.findAttribute(attribute_hide)){
        continue;
      }
      PVector f = new PVector(0, 0);
      for (Node node2 : nodes) {
        if(!node2.findAttribute(attribute_hide)){
          continue;
        }
        if ( node1 == node2 ) continue;
        f.add(force(node1, node2));
      }
      node1.v.x += f.x/M;
      node1.v.y += f.y/M;
      node1.v.x *= 0.9;
      node1.v.y *= 0.9;
      node1.p.x += node1.v.x;
      node1.p.y += node1.v.y;
    }
  }

  PVector force(Node n1, Node n2) {
    PVector f = new PVector();
    float F = C / pow(PVector.dist(n1.p, n2.p), 2);
    F = F > f_limit ? f_limit : F;
    f.x -= F * (n2.p.x - n1.p.x) / PVector.dist(n1.p, n2.p);
    f.y -= F * (n2.p.y - n1.p.y) / PVector.dist(n1.p, n2.p);
    if (is_connected(n1, n2)) {
      F = J * ( PVector.dist(n1.p, n2.p) - L);
      F = F > f_limit ? f_limit : F;
      f.x += F * (n2.p.x - n1.p.x) / PVector.dist(n1.p, n2.p);
      f.y += F * (n2.p.y - n1.p.y) / PVector.dist(n1.p, n2.p);
    }
    return f;
  }
  
  boolean is_connected(Node node1, Node node2) {
    for (Link link : node1.links) {
      if (link.to_node == node2) {
        return true;
      }
    }
    for(Link link : node2.links) {
      if (link.to_node == node1) {
        return true;
      }
    }
    return false;
  }
   
  void stroke_color(color c){
    stroke(red(c), green(c), blue(c), 100);
  }
  
  void fill_color(color c){
    fill(red(c), green(c), blue(c), 200);
  }
}
