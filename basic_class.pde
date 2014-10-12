
class Ganeza{
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Link> links = new ArrayList<Link>();
  View view = new View();
  Visualizer visualizer = new Visualizer(nodes, links);
  Analyzer analyzer = new Analyzer(nodes, links);
  Ganeza(String network_json) {
    init(network_json);
  }
  
  void init(String network_json){
    JSONObject json = loadJSONObject(network_json);
    JSONArray node_data_array = json.getJSONArray("nodes");
    //nodes
    for(int i=0; i<node_data_array.size(); i++){
      JSONObject node_data = node_data_array.getJSONObject(i);
      Node node = new Node(i, new PVector(random(width), random(height)), new PVector(0, 0));
      node.name = node_data.getString("node_name");
      String[] attrs = node_data.getJSONArray("attributes").getStringArray();
      for(int m=0; m<attrs.length; m++){
        node.attributes.add(attrs[m]);
      }
      nodes.add(node);
    }
    //links
    for(int from_id=0; from_id<node_data_array.size(); from_id++){
      JSONObject node_data = node_data_array.getJSONObject(from_id);
      String[] to_names = node_data.getJSONArray("link_to").getStringArray();
      for(int i=0; i<to_names.length; i++){
        int to_id = name_to_id(to_names[i]);
        if(to_id == -1) continue;
        Link link = new Link(from_id, to_id);
        links.add(link);
      }
    }    
  }
  
  int name_to_id(String name){
    for(Node node : nodes){
      if(node.name.equals(name)){
        return node.id;
      }
    }
    return -1;
  }
   
  Node getRandomNode(){
    return nodes.get((int)random(nodes.size()-1));
  }
  
  void addAttribute(ArrayList<Node> nodes, String attribute){
    for(Node node : nodes){
      node.attributes.add(attribute);
    }
  }
  
  void flushAttribute(String attribute){
    for(Node node : nodes){
      node.delete_attribute(attribute);
    }
  }
  
  void show() {
    translate(view.view_point.x, view.view_point.y);
    visualizer.run();
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

class Node {
  String name;
  ArrayList<String> attributes = new ArrayList<String>();
  PVector p;
  PVector v;
  int id;
  Node(int id_in, PVector p_in, PVector v_in) {
    id = id_in;
    p = p_in;
    v = v_in;
    init();
  }
  
  void init() {
    attributes.add("normal");
  }
  
  void delete_attribute(String attr){
    ArrayList<String> new_attributes = new ArrayList<String>();
    for(String str : attributes){
      if(!str.equals(attr)){
        new_attributes.add(str);
      }
    }
    attributes = new_attributes;
  }
  
  boolean findAttribute(String attr){
    for(String str : attributes){
      if(attr.equals(str)){
        return true;
      }
    }
    return false;
  }
}

class Link {
  int from_id;
  int to_id;
  int weight;
  Link(int from_id_in, int to_id_in) {
    from_id = from_id_in;
    to_id = to_id_in;
    init();
  }
  
  void init() {
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
