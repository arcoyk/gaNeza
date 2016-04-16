class Ganeza {
  String name = "non-name";
  ArrayList<Node> nodes = new ArrayList<Node>();
  Visualizer visualizer = new Visualizer(nodes);
  Analyzer analyzer = new Analyzer(nodes);
  ArrayList<Ganeza> subnetwork_list = new ArrayList<Ganeza>();
  Ganeza parent_network = null;
  
  Ganeza() {
  }
  
  Ganeza(String network_json) {
    init(network_json);
  }
  
  void init_nn(int layer_num, int node_num) {
    ArrayList<Node> before_nodes = new ArrayList<Node>();
    for (int layer_ind = 0; layer_ind < layer_num; layer_ind++) {
      ArrayList<Node> crr_nodes = new ArrayList<Node>();
      for (int node_ind = 0; node_ind < node_num; node_ind++) {
        String name = layer_ind + "_" + node_ind;
        Node node = new Node();
        node.name = name;
        node.value = 0;
        if (layer_ind > 0) {
          for (Node b_node : before_nodes) {
            Link link = new Link(b_node, node);
            b_node.links.add(link);
          }
        }
        nodes.add(node);
        crr_nodes.add(node);
      }
      before_nodes = crr_nodes;
    }
  }

  void init(String network_json) {
    JSONObject json = loadJSONObject(network_json);
    JSONArray node_data_array = json.getJSONArray("nodes");
    //nodes
    for (int i=0; i<node_data_array.size(); i++) {
      JSONObject node_data = node_data_array.getJSONObject(i);
      Node node = new Node(new PVector(random(width), random(height)), new PVector(0, 0));
      node.name = node_data.getString("node_name");
      nodes.add(node);
    }
    //links
    for (Node from_node : nodes) {
      JSONObject node_data = node_data_array.getJSONObject(nodes.indexOf(from_node));
      String[] to_names = node_data.getJSONArray("link_to").getStringArray();
      for (String to_name : to_names) {
        Node to_node = get_node(to_name);
        if (to_node == null) {
          println("ERROR: no such node " + to_name);
          continue;
        }
        Link link = new Link(from_node, to_node);
        from_node.links.add(link);
      }
    }
  }
  
  Node get_node(String node_name) {
    for (Node node : nodes) {
      if (node_name.equals(node.name)) {
        return node;
      }
    }
    return null;
  }
  
  Ganeza create_subnetwork(ArrayList<Node> org_nodes, String name, color c){
    Ganeza existing_subnetwork = get_subnetwork(name);
    if (existing_subnetwork != null) {
      subnetwork_list.remove(existing_subnetwork);
    }
    Ganeza subnetwork = new Ganeza();
    for (Node org_node : org_nodes) {
      Node sub_node = new Node(org_node.p, org_node.v);
      sub_node.name = org_node.name;
      sub_node.value = org_node.value;
      subnetwork.nodes.add(sub_node);
    }
    for (Node org_node : org_nodes) {
      Node from_node = subnetwork.get_node(org_node.name);
      if (from_node == null) continue;
      for (Link org_link : org_node.links) {
        Node to_node = subnetwork.get_node(org_link.to_node.name);
        if (to_node == null) continue;
        Link link = new Link(from_node, to_node);
        from_node.links.add(link);
      }
    }
    subnetwork.parent_network = network;
    subnetwork.visualizer = new Visualizer(subnetwork.nodes);
    subnetwork.visualizer.method = "";
    subnetwork.name = name;
    subnetwork.visualizer.c = c;
    subnetwork_list.add(subnetwork);
    return subnetwork;
  }
  
  Ganeza get_subnetwork(String subnetwork_name) {
    for (Ganeza subnetwork : subnetwork_list) {
      if (subnetwork.name.equals(subnetwork_name)) {
        return subnetwork;
      }
    }
    return null;
  }
  
  void show() {
    visualizer.visualize();
    for(Ganeza subnetwork : subnetwork_list){
      subnetwork.visualizer.visualize();
    }
  }
  
  // propagate value from n to linked node
  void propagate() {
    for (Node n : nodes) {
      if (n.value >= 1) {
        for (Link link : n.links) {
          if (link.weight > 50) {
            Node to_node = link.to_node;
            to_node.value += link.vote;
            to_node.propagated_links.add(link);
          }
        }
        if (n.box != null) {
          if (n.box.kind == "OUT") {
            // if the answer is correct
            if (n.box.value == 0) {
              back_propagate(n.propagated_links);
            }
          } else if (n.box.kind == "ANS") {
            n.box.value = 0;
          }
        }
        n.value = 0;
      }
    }
  }
  
  void back_propagate(ArrayList<Link> links) {
    for (Link link : links) {
      link.weight++;
    }
  }
  
  void attenuation(int rate) {
    if (rate == 0) {
      return;
    }
    for (Node n : nodes) {
      n.value -= n.value / rate;
    }
  }
  
  void random_rewired() {
    Node node1 = get_random_node();
    Node node2 = get_random_node();
    if (node1 == node2) {
      return;
    }
    Link link = node1.get_random_link();
    if (link != null) {
      link.to_node = node2;
    }
  }
  
  Node get_random_node() {
    return nodes.get((int)random(nodes.size()));
  }
        
  void mouse_select() {
    for (Node node : network.nodes) {
      float distance = sqrt(pow(mouseX - node.p.x, 2) + pow(mouseY - node.p.y, 2));
      if (distance < 10.0) {
        break;
      }
    }
  }
}

class Link {
  Node from_node;
  Node to_node;
  int weight = 100;
  int vote = 0;

  Link(Node from_node_in, Node to_node_in) {
    from_node = from_node_in;
    to_node = to_node_in;
    init();
  }
  
  void init(){
    if (random(1) < 0.5) {
      vote = -1;
    } else {
      vote = 1;
    }
  }
}

class Node implements Comparable{
  String name;
  ArrayList<Link> links = new ArrayList<Link>();
  ArrayList<Link> propagated_links = new ArrayList<Link>();
  PVector p;
  PVector v;
  float value = 0;
  Box box;
  
  Node(PVector p_in, PVector v_in) {
    p = p_in;
    v = v_in;
    init();
  }
  
  Node(){
    p = new PVector(random(width), random(height));
    v = new PVector(random(1), random(1));
    init();
  }
  
  void bind(Box in_box) {
    box = in_box;
  }
  
  void init() {
  }
  
  int compareTo(Object other){
    Node other_node = (Node)other;
    return (int)(value - other_node.value);
  }
  
  Link get_random_link() {
    if (links.size() == 0) return null;
    return links.get((int)random(links.size()));
  }
  
}

class View {
  PVector view_point = new PVector(0, 0);
  float scale = 1.0;
  PVector mouse_anchor = new PVector(0, 0);
  PVector view_point_anchor = new PVector();
  
  View() {
  }
  
  void mousePressed() {
    view_point_anchor.x = view_point.x;
    view_point_anchor.y = view_point.y;
    mouse_anchor.x = mouseX;
    mouse_anchor.y = mouseY;
  }
  
  void mouseDragged() {
    scale = scale == 0 ? 0.2 : scale;
    view_point.x = view_point_anchor.x + (mouseX - mouse_anchor.x) / scale;
    view_point.y = view_point_anchor.y + (mouseY - mouse_anchor.y) / scale;
  }
  
  void mouseWheel(MouseEvent event){
    scale += event.getCount() / 100.0;
    if(scale < 0.2){
      scale = 0.2;
    }
  }
}