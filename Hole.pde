class Hole {
  PVector pos;
  float r;

  Hole(PVector pos, float r) {
    this.pos = pos;
    this.r = r;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y, -r * 0.5);
    noStroke();
    
    fill(20, 20, 20);

    sphereDetail(30);
    sphere(r);

    popMatrix();
  }
}
