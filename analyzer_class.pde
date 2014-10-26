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
    ArrayList<Node> path = new ArrayList<Node>();
    PriorityQueue queue = new PriorityQueue();
    queue.push(start, 0);
    while(queue.empty() == false){
     PQ next = queue.pop();
     for(Link link : next.node.links){
       int weight_sum = next.weight + link.weight;
       PQ crr_to_node = queue.exist(link.to_node);
       if(crr_to_node != null && crr_to_node.weight > weight_sum){
         queue.find(crr_to_node).weight = weight_sum;
       }else{
         queue.push(link.to_node, weight_sum);
       }
     }
    }
    return path;
  }

}
