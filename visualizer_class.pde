class Visualizer{
  int C = 130000;
  int J = 1;
  int L = 50;
  int M = 10;
  int f_limit = 10;
  int circle_rad = 200;
  int size_limit = 1500;
  ArrayList<Node> nodes;
  ArrayList<Link> links;
  String method = "FORCE_DIRECTED";
  String attribute_limit = "normal";
  color wine_red = color(255, 100, 50);
  color deep_blue = color(20, 20, 255);
  color white = color(255, 255, 255);
  color gray = color(200, 200, 200);
  color black = color(0, 0, 0);
  Visualizer(ArrayList<Node> in_nodes, ArrayList<Link> in_links) {
    nodes = in_nodes;
    links = in_links;
  }
  
  void run(){
    if (method == "FORCE_DIRECTED") {
      run_force_directed();
    }else if (method == "CIRCLE") {
      run_circle();
    }
    for (Link link : links) {
      PVector from_posi = nodes.get(link.from_id).p;
      PVector to_posi = nodes.get(link.to_id).p;
      if(!nodes.get(link.from_id).findAttribute(attribute_limit) ||
         !nodes.get(link.to_id).findAttribute(attribute_limit)) {
           continue;
      }
      stroke_color(gray);
      line(from_posi.x, from_posi.y, to_posi.x, to_posi.y);
      stroke_color(black);
    }
    for (Node node : nodes) {
      if(!node.findAttribute(attribute_limit)){
        continue;
      }
      stroke_color(black);
      fill_color(black);
      ellipse(node.p.x, node.p.y, 10, 10);
      textSize(20);
      text(node.name, node.p.x, node.p.y-5);
      stroke_color(white);
      fill_color(white);
    }
  }
  
  void run_circle(){
    int cnt = 0;
    for(Node node : nodes){
      if(!node.findAttribute(attribute_limit)){
        continue;
      }
      cnt++;
    }
    float interval = 2*PI/cnt;
    PVector center = new PVector(width/2, height/2);
    cnt = 0;
    for (Node node : nodes) {
      if(!node.findAttribute(attribute_limit)){
        continue;
      }
      cnt++;
      node.p.x = center.x + circle_rad * cos(interval * cnt);
      node.p.y = center.y + circle_rad * sin(interval * cnt);
    }
  }
  
  void run_force_directed() {
    for (Node node1 : nodes) {
      if(!node1.findAttribute(attribute_limit)){
        continue;
      }
      PVector f = new PVector(0, 0);
      for (Node node2 : nodes) {
        if(!node2.findAttribute(attribute_limit)){
          continue;
        }
        if ( node1.id == node2.id ) continue;
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
    float F = C / pow( PVector.dist(n1.p, n2.p), 2);
    F = F > f_limit ? f_limit : F;
    f.x -= F * (n2.p.x-n1.p.x) / PVector.dist(n1.p, n2.p);
    f.y -= F * (n2.p.y-n1.p.y) / PVector.dist(n1.p, n2.p);
    if (connected(n1, n2)) {
      F = J * ( PVector.dist(n1.p, n2.p) - L);
      F = F > f_limit ? f_limit : F;
      f.x += F * (n2.p.x-n1.p.x) / PVector.dist(n1.p, n2.p);
      f.y += F * (n2.p.y - n1.p.y) / PVector.dist(n1.p, n2.p);
    }
    return f;
  }
  
  boolean connected(Node n1, Node n2) {
    for(int i=0; i<links.size(); i++){
      int id1 = n1.id;
      int id2 = n2.id;
      Link link = links.get(i);
      if((link.from_id == id1 && link.to_id == id2) || (link.from_id == id2 && link.to_id == id1)){
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
