class Analyzer{
  ArrayList<Node> nodes;
  ArrayList<Link> links;
  Analyzer(ArrayList<Node> nodes_in , ArrayList<Link> links_in){
    nodes = nodes_in;
    links = links_in;
  }
  
  void init(){
  }
  
  boolean connected(Node n1, Node n2) {
    for(Link link : links){
      int id1 = n1.id;
      int id2 = n2.id;
      if((link.from_id == id1 && link.to_id == id2) || (link.from_id == id2 && link.to_id == id1)){
        return true;
      }
    }
    return false;
  }     
}
