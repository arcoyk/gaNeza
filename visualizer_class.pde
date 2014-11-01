import java.util.Map;

class Visualizer {
  int C = 130000;
  int J = 1;
  int L = 50;
  int M = 10;
  int f_limit = 10;
  int min_dist = 30;
  int size_limit = 1500;
  ArrayList<Node> nodes;
  String method = "FORCE_DIRECTED";
  color c = color(0);
  
  Visualizer(ArrayList<Node> in_nodes) {
    nodes = in_nodes;
  }
  
  void visualize() {
    if (method == "FORCE_DIRECTED") {
      force_directed();
    }else if (method == "CIRCLE") {
      circle();
    }else if (method == "LINEUP") {
      line_up();
    }
    fill(c);
    stroke(c);
    show();
    fill(0);
    stroke(0);
  }
  
  void show() {
    for (Node node : nodes) {
      for (Link link : node.links) {
        line(node.p.x, node.p.y, link.to_node.p.x, link.to_node.p.y);
        strokeWeight(2);
        line(node.p.x, node.p.y, node.p.x + (link.to_node.p.x - node.p.x) / 4, node.p.y + (link.to_node.p.y - node.p.y) / 4);
        strokeWeight(1);
      }
    }
    for (Node node : nodes) {
      textSize(20);
      ellipse(node.p.x, node.p.y, 10, 10);
      text(node.name, node.p.x, node.p.y - 5);
    }
  }
  
  void line_up() {
    int interval = min_dist * 3;
    int div = (int)sqrt(nodes.size());
    for(int i=0; i<nodes.size(); i++){
      Node node = nodes.get(i);
      node.p.x = interval * (i % div);
      node.p.y = interval * (int)(i / div);
    }
  }
  
  void circle() {
    int cnt = 0;
    for (Node node : nodes) {
      cnt++;
    }
    float circle_rad = min_dist / (2 * sin(PI / cnt));
    float interval = 2 * PI / cnt;
    PVector center = new PVector(width/2, height/2);
    cnt = 0;
    for (Node node : nodes) {
      cnt++;
      node.p.x = center.x + circle_rad * cos(interval * cnt);
      node.p.y = center.y + circle_rad * sin(interval * cnt);
    }
  }
  
  void force_directed() {
    for (Node node1 : nodes) {
      PVector f = new PVector(0, 0);
      for (Node node2 : nodes) {
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
    for (Link link : node2.links) {
      if (link.to_node == node1) {
        return true;
      }
    }
    return false;
  }
}
