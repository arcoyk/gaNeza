import java.util.TreeSet;

class Analyzer {
  ArrayList<Node> nodes;
  Analyzer(ArrayList<Node> nodes_in) {
    nodes = nodes_in;
  }
  
  void init() {
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
    ArrayList<Node> path = new ArrayList<Node>();
    TreeSet<Node> queue = new TreeSet<Node>();
    queue.add(start);
    while(!queue.isEmpty()){
     Node next = queue.first();
     for(Link link : next.links){
      Node neighbor = link.to_node;
      float weight_sum = next.value + link.weight;
      if(queue.contains(neighbor)){
        neighbor.value = neighbor.value < weight_sum ? neighbor.value : weight_sum;
      }else{
        neighbor.value = weight_sum;
        queue.add(neighbor);
      }
     }
     path.add(next);
    }
    clear_node_value();
    return path;
  }
  
  void clear_node_value(){
    for(Node node : nodes){
      node.value = 0;
    }
  }
  
}


