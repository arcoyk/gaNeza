class Analyzer{
  ArrayList<Node> nodes;
  ArrayList<Link> links;
  
  Analyzer(ArrayList<Node> nodes_in , ArrayList<Link> links_in){
    nodes = nodes_in;
    links = links_in;
  }
  void init(){
  }
  
  int link_count(ArrayList<Node> nodes){
    int count = 0;
    for(Node node1 : nodes){
      for(Node node2 : nodes){
        if(connected(node1, node2)){
          count++;
        }
      }
    }
    return count;
  }
  
  float link_distribution(ArrayList<Node> nodes){
    ArrayList<Integer> hub_point = new ArrayList<Integer>();
    for(Node node1 : nodes){
      int count = 0;
      for(Node node2 : nodes){
        if(connected(node1, node2)){
          count++;
        }
      }
      hub_point.add(count);
    }
    float distribution = 0;
    for(Integer point1 : hub_point){
      for(Integer point2 : hub_point){
        distribution += abs(point1 - point2);
      }
    }
    distribution /= 2;
    return distribution/nodes.size();
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
