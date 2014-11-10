class Ganeza {
  String name = "non-name";
  ArrayList<Node> nodes = new ArrayList<Node>();
  View view = new View();
  Visualizer visualizer = new Visualizer(nodes);
  Analyzer analyzer = new Analyzer(nodes);
  ArrayList<Ganeza> subnetwork_list = new ArrayList<Ganeza>();
  Ganeza parent_network = null;
  
  Ganeza() {
  }
  
  Ganeza(String network_json) {
    init(network_json);
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
  
  void create_subnetwork(ArrayList<Node> org_nodes, String name, color c){
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
    translate(width / 2 - width * view.scale / 2, height / 2 - height * view.scale / 2);
    scale(view.scale);
    translate(view.view_point.x, view.view_point.y);
    visualizer.visualize();
    for(Ganeza subnetwork : subnetwork_list){
      subnetwork.visualizer.visualize();
    }
  }
  
  void mousePressed() {
    view.mousePressed();
  }
  
  void mouseDragged() {
    view.mouseDragged();
  }
  
  void mouseWheel(MouseEvent event){
    view.mouseWheel(event);
  }
}

class Link {
  Node from_node;
  Node to_node;
  int weight = 1;

  Link(Node from_node_in, Node to_node_in) {
    from_node = from_node_in;
    to_node = to_node_in;
    init();
  }
  
  void init(){
  }
}

class Node implements Comparable{
  String name;
  ArrayList<Link> links = new ArrayList<Link>();
  PVector p;
  PVector v;
  float value = 0;
  
  Node(PVector p_in, PVector v_in) {
    p = p_in;
    v = v_in;
    init();
  }
  
  void init() {
  }
  
  int compareTo(Object other){
    Node other_node = (Node)other;
    return (int)(value - other_node.value);
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


