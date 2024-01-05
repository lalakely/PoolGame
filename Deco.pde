class BorderDeco {
  PVector pos;
  int w;
  int h;

  public BorderDeco(PVector pos, int w, int h) {
    this.pos = pos;
    this.w = w;
    this.h = h;
  }

  void show() {
    fill(#3E2723);
    rect(pos.x, pos.y, w, h , 20);
    noStroke();
  }
}
