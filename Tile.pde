class Tile {
  //3 points of the triangle
  PVector p1;     
  PVector p2;
  PVector p3; 

  int counter;      // How many bombs are next to tile 

  boolean red;      // draw square as red
  boolean visited;  // used during the flipping multiple things
  boolean space;    // shows whether a bomb oready there or not
  boolean check;    // shows what's hiding
  boolean mine;     // whether it has a mine or not
  boolean up;       // which direction the triangle is facing

  Tile(PVector a, PVector b, PVector c, boolean dir) {
    p1 = a.copy(); 
    p2 = b.copy();
    p3 = c.copy(); 

    counter = 0; 
    red = false;
    visited = false; 
    space = false;
    check = false; 
    mine = false;
    up = dir;
  }

  void reset() {
    visited = false; 
    check = false;
    mine = false;
    space = false;
    red = false;
    counter = 0;
  }

  void show() {
    int tileSize = int(p3.x - p1.x); 
    stroke(0); 
    strokeWeight(1);
    if (red) {
      fill(255, 0, 0);
      triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    } else if (check) {
      fill(255); 
      triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
      if (mine) { 
        fill(51);
        ellipse(p2.x - 2, (p1.y + p2.y + p3.y)/3, tileSize/4, tileSize/4);
      } else {
        if (counter == 0) {
          fill(255);
        } else if (counter == 1) {
          fill(0, 0, 255);
        } else if (counter == 2) {
          fill(0, 255, 0);
        } else if (counter == 3) {
          fill(255, 255, 0);
        } else if (counter == 4) {
          fill(255, 75, 0);
        } else if (counter > 4) {
          fill(255, 0, 0);
        }
        text(counter, p2.x - 2, (p1.y + p2.y + p3.y)/3);
      }
    } else {
      fill(175);
      triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    }
  }

  void cover() {
    if (PointInTriangle(mouse, p1, p2, p3) && !check) {
      red = !red;
    }
  }

  boolean click() {
    if (!red && !check && PointInTriangle(mouse, p1, p2, p3)) {
      check = true;
      return (mine || counter==0);
    }
    return false;
  }

  private boolean PointInTriangle(PVector p, PVector p1, PVector p2, PVector p3) {
    float alpha = ((p2.y - p3.y)*(p.x - p3.x) + (p3.x - p2.x)*(p.y - p3.y)) / ((p2.y - p3.y)*(p1.x - p3.x) + (p3.x - p2.x)*(p1.y - p3.y));
    float beta = ((p3.y - p1.y)*(p.x - p3.x) + (p1.x - p3.x)*(p.y - p3.y)) / ((p2.y - p3.y)*(p1.x - p3.x) + (p3.x - p2.x)*(p1.y - p3.y));
    float gamma = 1.0 - alpha - beta;

    return (alpha > 0 && beta > 0 && gamma > 0);
  }
}