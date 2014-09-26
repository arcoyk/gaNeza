//This software is released under the MIT License.
//Copyright(c) 2014 Yui Arco Kita

Ganeza network;
void setup() {
  size(1100, 700);
  network = new Ganeza("recipe_ethnic_american.json");
  network.visualizer.method = "FORCE_DIRECTED";
}

ArrayList<Node> nodes;
float max_point = 0;
boolean stop = false;
void draw() {
  if(stop) return;
  //analysis
  ArrayList<Node> cand_nodes = new ArrayList<Node>();
  Node crr_node = network.nodes.get((int)random(network.nodes.size()));
  for(int i=0; i<(int)random(5, network.nodes.size()/6); i++){
    //nodes.add(network.getRandomNode());
    ArrayList<Node> next_nodes = new ArrayList<Node>();
    for(Link link : network.links){
      if(link.from_id == crr_node.id){
        for(Node node : network.nodes){
          if(link.to_id == node.id){
            next_nodes.add(node);
            break;
          }
        }
      }else if(link.to_id == crr_node.id){
        for(Node node : network.nodes){
          if(link.from_id == node.id){
            next_nodes.add(node);
            break;
          }
        }
      }
    }
    crr_node = next_nodes.get((int)random(next_nodes.size()));
    cand_nodes.add(crr_node);
  }

  network.flushAttribute("selecting");
  network.addAttribute(cand_nodes, "selecting");
  int link_count = network.analyzer.link_count(cand_nodes);
  float link_distribution = network.analyzer.link_distribution(cand_nodes);
  float link_count_per_node = link_count/cand_nodes.size();
  float point = link_distribution/link_count_per_node;
  if(point > max_point){
    max_point = point;
    network.flushAttribute("stable");
    network.addAttribute(cand_nodes, "stable");
  }

  background(255);
  network.show();
}

void mousePressed(){
  network.mousePressed();
}

void mouseDragged(){
  network.mouseDragged();
}

void keyPressed(){
  if (key == 'a') {
    stop = !stop;
  }else if(key == 'c'){
    network.visualizer.method = "CIRCLE";
  }else if(key == 'f'){
    network.visualizer.method = "FORCE_DIRECTED";
  }else if(key == 's'){
    network.visualizer.limit = "stable";
  }else if(key == 'n'){
    network.visualizer.limit = "normal";
  }
}
