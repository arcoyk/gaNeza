import java.util.PriorityQueue;
import java.util.Map;

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
    for (Link link : node2.links) {
      if (link.to_node == node1) {
        return true;
      }
    }
    return false;
  }
    
  HashMap<Node, Node> shortest_distance(Node start, Node goal) {
    ArrayList<Node> used = new ArrayList<Node>();
    PriorityQueue<Node> queue = new PriorityQueue<Node>();
    HashMap<Node, Node> flow = new HashMap<Node, Node>();
    queue.add(start);
    while (!queue.isEmpty()) {
      Node next = queue.poll();
      used.add(next);
      if (next == goal) {
        break;
      }
      for (Link link : next.links) {
        Node neighbor = link.to_node;
        if (used.contains(neighbor)) {
          continue;
        }
        float weight_sum = next.value + link.weight;
        if (queue.contains(neighbor)) {
          if (weight_sum < neighbor.value) {
            neighbor.value = weight_sum;
            flow.put(next, neighbor);
          }
        }else {
          neighbor.value = weight_sum;
          queue.add(neighbor);
          flow.put(next, neighbor);
        }
      }
    }
    float result = goal.value;
    clear_node_value();
    //return result;
    for (Map.Entry e : flow.entrySet()) {
      Node from = (Node)e.getKey();
      Node to = (Node)e.getValue();
      println(from.name + " found " + to.name);
      if(to == goal){
        println("GOAL");
      }
    }
    println(result);
    println();
    return flow;
  }
  
  void clear_node_value() {
    for (Node node : nodes) {
      node.value = 0;
    }
  }
}


