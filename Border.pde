class Border {
  PVector pos;
  int w;
  int h;

  public Border(PVector pos, int w, int h) {
    this.pos = pos;
    this.w = w;
    this.h = h;
  }

  void show() {
    fill(#D2CB99);
    rect(pos.x, pos.y, w, h);
    noStroke();
  }
}
