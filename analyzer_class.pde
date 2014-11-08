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
    int cnt = 0;
    queue.add(start);
    while(!queue.isEmpty()){
      if(cnt++ > 100){
        break;
      }
     Node next = queue.pollFirst();
     if(next == goal){
       path.add(goal);
       break;
     }
     for(Link link : next.links){
      Node neighbor = link.to_node;
      if(path.contains(neighbor)){
        continue;
      }
      float weight_sum = next.value + link.weight;
      if(queue.contains(neighbor)){
        if(weight_sum < neighbor.value){
          neighbor.value = weight_sum;
          if(!path.contains(next)) path.add(next);
        }
      }else {
        neighbor.value = weight_sum;
        queue.add(neighbor);
        if(!path.contains(next)) path.add(next);
      }
     }
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


