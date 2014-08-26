//Force-directed graph drawing
//This software is released under the MIT License. Copyright(c) 2014 Yui Arco Kita

class View {
  PVector view_point = new PVector(0, 0);
  float scale = 1.0;
  PVector mouse_anchor = new PVector(0, 0);
  PVector view_point_anchor = new PVector();
  View() {
  }
  void init() {
  }
}

class Node {
  PVector p;
  PVector v;
  int id;
  Node() {
  }
  void init(int id_in, PVector p_in, PVector v_in) {
    id = id_in;
    p = p_in;
    v = v_in;
  }
}

class Link {
  int from_id;
  int to_id;
  Link() {
  }
  void init(int from_id_in, int to_id_in) {
    from_id = from_id_in;
    to_id = to_id_in;
  }
}

ArrayList<Link> ls = new ArrayList<Link>();
ArrayList<Node> ns = new ArrayList<Node>();
View v = new View();

void setup() {
  size(1000, 1000);
  init_all();
  println("press a");
}

void draw() {
  background(255);
  motion();
  show();
}

void init_all() {
  // nodes
  for (int i=0; i<20; i++) {
    Node n = new Node();
    n.init(i, new PVector(random(width), random(height)), new PVector(0, 0));
    ns.add(n);
  }
  // links
  for (int i=0; i<20; i++) {
    Link link = new Link();
    link.init((int)random(ns.size()), (int)random(ns.size()));
    ls.add(link);
  }
}

void mousePressed() {
  v.view_point_anchor.x = v.view_point.x;
  v.view_point_anchor.y = v.view_point.y;
  v.mouse_anchor.x = mouseX;
  v.mouse_anchor.y = mouseY;
}

void mouseDragged(){
  v.view_point.x = v.view_point_anchor.x + (mouseX - v.mouse_anchor.x);
  v.view_point.y = v.view_point_anchor.y + (mouseY - v.mouse_anchor.y);
}


void show(){
  translate(v.view_point.x, v.view_point.y);
  for (int i=0; i<ls.size(); i++) {
    Link ln = ls.get(i);
    PVector from_posi = ns.get(ln.from_id).p;
    PVector to_posi = ns.get(ln.to_id).p;
    line(from_posi.x, from_posi.y, to_posi.x, to_posi.y);
  }
  for (int i=0; i<ns.size(); i++) {
    Node n = ns.get(i);
    ellipse(n.p.x, n.p.y, 10, 10);
  }
}

int C = 5000;
int J = 1;
int L = 50;
int M = 10;
int f_limit = 10;

void keyPressed() {
  if (key == 'c') {
    C = 8000;
  }else if (key == 'C') {
    C = 5000;
  }else if (key == 'a') {
    auto_node_gen();
  }
}

int size_limit = 150;
void motion() {
  for (int i=0; i<ns.size(); i++) {
    Node n1 = ns.get(i);
    PVector f = new PVector(0, 0);
    if (ns.size() > size_limit){
      for(int s=0; s<size_limit; s++) {
        int m = (int)random(ns.size());
        if( i == m ) continue;
        Node n2 = ns.get(m);
        f.add(force(n1, n2));
      }
    }else {
      for (int m=0; m<ns.size(); m++) {
        if( i == m ) continue;
        Node n2 = ns.get(m);
        f.add(force(n1, n2));
      }
    }
    n1.v.x += f.x/M;
    n1.v.y += f.y/M;
    n1.v.x *= 0.9;
    n1.v.y *= 0.9;
    n1.p.x += n1.v.x;
    n1.p.y += n1.v.y;
  }
}

PVector force(Node n1, Node n2) {
  PVector f = new PVector();
  float F = C / pow( PVector.dist(n1.p, n2.p), 2);
  F = F > f_limit ? f_limit : F;
  f.x -= F*(n2.p.x-n1.p.x)/PVector.dist(n1.p, n2.p);
  f.y -= F*(n2.p.y-n1.p.y)/PVector.dist(n1.p, n2.p);
  if (connected(n1, n2)) {
    F = J * ( PVector.dist(n1.p, n2.p) - L);
    F = F > f_limit ? f_limit : F;
    f.x += F*(n2.p.x-n1.p.x)/PVector.dist(n1.p, n2.p);
    f.y += F*(n2.p.y-n1.p.y)/PVector.dist(n1.p, n2.p);
  }
  return f;
}

void auto_node_gen() {
  Node n = new Node();
  n.init(ns.size(), new PVector(random(width), random(height)), new PVector());
  ns.add(n);
  Link link = new Link();
  link.init((int)random(ns.size()-2), ns.size()-1);
  ls.add(link);
  link = new Link();
  link.init((int)random(ns.size()-2), (int)random(ns.size()-2));
  ls.add(link);
}

boolean connected(Node n1, Node n2) {
  for(int i=0; i<ls.size(); i++){
    int id1 = n1.id;
    int id2 = n2.id;
    Link link = ls.get(i);
    if((link.from_id == id1 && link.to_id == id2) || (link.from_id == id2 && link.to_id == id1)){
      return true;
    }
  }
  return false;
}

