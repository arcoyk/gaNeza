
class Ganeza{
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Link> links = new ArrayList<Link>();
  View view = new View();
  Visualizer visualizer = new Visualizer(nodes, links);
  
  Ganeza(String json) {
  }
  
  void init() {
    // nodes
    for (int i=0; i<20; i++) {
      Node n = new Node();
      n.init(i, new PVector(random(width), random(height)), new PVector(0, 0));
      nodes.add(n);
    }
    // links
    for (int i=0; i<20; i++) {
      Link link = new Link();
      link.init((int)random(nodes.size()), (int)random(nodes.size()));
      links.add(link);
    }
  }
  
  void show() {
    visualizer.run();
    translate(view.view_point.x, view.view_point.y);
    for (int i=0; i<links.size(); i++) {
      Link link = links.get(i);
      PVector from_posi = nodes.get(link.from_id).p;
      PVector to_posi = nodes.get(link.to_id).p;
      line(from_posi.x, from_posi.y, to_posi.x, to_posi.y);
    }
    for (int i=0; i<nodes.size(); i++) {
      Node n = nodes.get(i);
      ellipse(n.p.x, n.p.y, 10, 10);
    }
  }
  
  void mousePressed() {
    view.view_point_anchor.x = view.view_point.x;
    view.view_point_anchor.y = view.view_point.y;
    view.mouse_anchor.x = mouseX;
    view.mouse_anchor.y = mouseY;
  }

  void mouseDragged(){
    view.view_point.x = view.view_point_anchor.x + (mouseX - view.mouse_anchor.x);
    view.view_point.y = view.view_point_anchor.y + (mouseY - view.mouse_anchor.y);
  }

  void keyPressed() {
    if (key == 'a') {
      auto_node_gen();
    }else if(key == 'c'){
      visualizer.C = 5000;
    }else if(key == 'v'){
      visualizer.C = 8000;
    }
  }

  void auto_node_gen() {
    Node n = new Node();
    n.init(nodes.size(), new PVector(random(width), random(height)), new PVector());
    nodes.add(n);
    Link link = new Link();
    link.init((int)random(nodes.size() - 2), nodes.size() - 1);
    links.add(link);
    link = new Link();
    link.init((int)random(nodes.size() - 2), (int)random(nodes.size() - 2));
    links.add(link);
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
