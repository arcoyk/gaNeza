class Box {
  PVector index = new PVector(0, 0);
  PVector p = new PVector(0, 0);
  int value = 255;
  String kind = "";
  Box(PVector index_in) {
    index = index_in;
  }  
}

class BoxImage {
  ArrayList<Box> boxes = new ArrayList<Box>();
  int b_width;
  int b_height;

  BoxImage(int in_w, int in_h) {
    b_width = in_w;
    b_height = in_h;
    for (int h = 0; h < b_height; h++) {
      for (int w = 0; w < b_width; w++) {
        boxes.add(new Box(new PVector(w, h)));
      }
    }
  }
  
  BoxImage(String shape, String kind, int in_w, int in_h) {
    b_width = in_w;
    b_height = in_h;
      for (int h = 0; h < b_height; h++) {
        for (int w = 0; w < b_width; w++) {
          Box box = new Box(new PVector(w, h));
          if (shape == "TRIANGLE") {
            if ((w+1) / (h+1) < 1) {
              box.value = 0;
            } else {
              box.value = 255;
            }
          } else if (shape == "BLANK") {
          }
          box.kind = kind;
          boxes.add(box);
        }
      }
    }
  
  Box get_by_index(int index) {
    if (index >= boxes.size()) {
      return null;
    } else {
      return boxes.get(index);
    }
  }
    
  void show(PVector p) {
    int w = 30;
    for (Box box : boxes) {
      fill(box.value, box.value, box.value, 100);
      box.p.x = p.x + box.index.x * w;
      box.p.y = p.y + box.index.y * w;
      rect(box.p.x, box.p.y, w, w);
    }
  }
  
  void flip(String how) {
    if (how == "VERTICAL") {
      for (int h = 0; h < b_height; h++) {
        for (int w = 0; w < b_width; w++) {
          Box box = get_by_index(b_width * h + w);
          if (box != null) {
            box.index.x = b_width - w;
            box.index.y = h;
          }
        }
      }
    }
  }
}