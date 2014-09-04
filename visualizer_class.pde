class Visualizer{
  int C = 5000;
  int J = 1;
  int L = 50;
  int M = 10;
  int f_limit = 10;
  int size_limit = 1500;
  ArrayList<Node> ns;
  ArrayList<Link> ls;
  String method = "";
  
  Visualizer(ArrayList<Node> nodes, ArrayList<Link> links) {
    ns = nodes;
    ls = links;
  }

  void run(){
    if (method == "FORCE_DIRECTED") {
      run_force_directed();
    }
  }
  
  void run_force_directed() {
    for (int i=0; i<ns.size(); i++) {
      Node n1 = ns.get(i);
      PVector f = new PVector(0, 0);
      if (ns.size() > size_limit){
        for (int s=0; s<size_limit; s++) {
          int m = (int)random(ns.size());
          if ( i == m ) continue;
          Node n2 = ns.get(m);
          f.add(force(n1, n2));
        }
      }else {
        for (int m=0; m<ns.size(); m++) {
          if ( i == m ) continue;
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
}
