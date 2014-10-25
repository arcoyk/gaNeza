class Ganeza{
  ArrayList<Node> nodes = new ArrayList<Node>();
  View view = new View();
  Visualizer visualizer = new Visualizer(nodes);
  Analyzer analyzer = new Analyzer(nodes);
  Ganeza(String network_json) {
    init(network_json);
  }
  
  void init(String network_json){
    JSONObject json = loadJSONObject(network_json);
    JSONArray node_data_array = json.getJSONArray("nodes");
    //nodes
    for (int i=0; i<node_data_array.size(); i++) {
      JSONObject node_data = node_data_array.getJSONObject(i);
      Node node = new Node(new PVector(random(width),random(height)), new PVector(0, 0));
      node.name = node_data.getString("node_name");
      String[] attrs = node_data.getJSONArray("attributes").getStringArray();
      for (int m = 0; m < attrs.length; m++) {
        node.attributes.add(attrs[m]);
      }
      nodes.add(node);
    }
    
    //links
    for (Node from_node : nodes) {
      JSONObject node_data = node_data_array.getJSONObject(nodes.indexOf(from_node));
      String[] to_names = node_data.getJSONArray("link_to").getStringArray();
      for(String to_name : to_names){
        Node to_node = get_node(to_name);
        if(to_node == null){
          println("ERROR: no such node " + to_name);
          continue;
        }
        Link link = new Link(from_node, to_node);
        from_node.links.add(link);
      }
    }
  }
  
  Node get_node(String node_name){
    for (Node node : nodes) {
      if (node_name.equals(node.name)) {
        return node;
      }
    }
    return null;
  }
  
  void addAttribute(ArrayList<Node> nodes, String attribute){
    for (Node node : nodes) {
      node.attributes.add(attribute);
    }
  }
  
  void flushAttribute(String attribute){
    for (Node node : nodes) {
      node.delete_attribute(attribute);
    }
  }
  
  void show() {
    translate(view.view_point.x, view.view_point.y);
    visualizer.visualize();
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
}

class Link {
  Node from_node;
  Node to_node;
  int weight;
  Link(Node from_node_in, Node to_node_in) {
    from_node = from_node_in;
    to_node = to_node_in;
  }
}

class Node {
  String name;
  ArrayList<Link> links = new ArrayList<Link>();
  ArrayList<String> attributes = new ArrayList<String>();
  PVector p;
  PVector v;
  int id;
  Node(PVector p_in, PVector v_in) {
    p = p_in;
    v = v_in;
    init();
  }
  
  void init() {
    attributes.add("normal");
  }
  
  void delete_attribute(String attr){
    ArrayList<String> new_attributes = new ArrayList<String>();
    for (String str : attributes) {
      if (!str.equals(attr)) {
        new_attributes.add(str);
      }
    }
    attributes = new_attributes;
  }
  
  boolean findAttribute(String attr){
    for (String str : attributes) {
      if (attr.equals(str)) {
        return true;
      }
    }
    return false;
  }
}

class View {
  PVector view_point = new PVector(0, 0);
  float scale = 1.0;
  PVector mouse_anchor = new PVector(0, 0);
  PVector view_point_anchor = new PVector();
  View() {
  }  
}
