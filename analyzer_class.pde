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
  
  ArrayList<Node> shortest_distance(Node start, Node goal) {
    if (start == goal) {
      ArrayList<Node> start_alone = new ArrayList<Node>();
      start_alone.add(start);
      return start_alone;
    }
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
            flow.put(neighbor, next);
          }
        }else {
          neighbor.value = weight_sum;
          queue.add(neighbor);
          flow.put(neighbor, next);
        }
      }
    }
    clear_node_value();
    if (!flow.containsKey(goal)) {
      return new ArrayList<Node>();
    }
    ArrayList<Node> path = new ArrayList<Node>();
    Node tracker = goal;
    while (tracker != start) {
      path.add(tracker);
      tracker = flow.get(tracker);
    }
    path.add(start);
    return path;
  }
  
  void clear_node_value() {
    for (Node node : nodes) {
      node.value = 0;
    }
  }
  
  float standard_deviation(ArrayList<Float> arr) {
    float result = 0;
    for (int i = 0; i < arr.size(); i++) {
      for (int m = i + 1; m < arr.size(); m++) {
        result += abs(arr.get(i) - arr.get(m));
      }
    }
    return result / arr.size();
  }
  
  float average(ArrayList<Float> arr) {
    float result = 0;
    for (int i = 0; i < arr.size(); i++) {
      result += arr.get(i);
    }
    return result / arr.size();
  }
  
  Profile get_profile(ArrayList<Node> nodes){
    Profile profile = new Profile();
    ArrayList<Node> path = new ArrayList<Node>();
    float long_distance = 100000;
    ArrayList<Float> distance_set = new ArrayList<Float>();
    for (int i = 0; i < nodes.size() - 1; i++) {
      for (int m = i + 1; m < nodes.size(); m++) {
        Node node1 = nodes.get(i);
        Node node2 = nodes.get(m);
        path = network.analyzer.shortest_distance(node1, node2);
        if (path.size() < 2) {
          distance_set.add(long_distance);
          continue;
        }
        float distance_in_path = 0;
        for (int k = 0; k < path.size() - 1; k++) {
          Node to_node = path.get(k);
          Node from_node = path.get(k + 1);
          for (Link link : from_node.links) {
            if (link.to_node == to_node) {
              distance_in_path += link.weight;
              break;
            }
          }
        }
        distance_set.add(distance_in_path);
      }
    }
    profile.average_distance = average(distance_set);
    profile.standard_deviation_distance = standard_deviation(distance_set);
    return profile;
  }
}

class Profile {
  Profile() {
  }
  float average_distance = 0;
  float standard_deviation_distance = 0;
}