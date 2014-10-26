class Analyzer{
  ArrayList<Node> nodes;
  Analyzer(ArrayList<Node> nodes_in){
    nodes = nodes_in;
  }
  
  void init(){
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
  
  ArrayList<Node> shortest_path(Node start, Node goal){
    
  }

}
