float friction = -0.007;

class Ball {
  PVector pos = new PVector(0, 0, 0),
    v = new PVector(0, 0, 0),
    a = new PVector(0, 0, 0);
  float r;
  color col;
  int num;
  boolean eaten = false;
  float holeR = 20;
  PVector[] holesPos = {
    new PVector(10 + borderT, 10 + borderT, 0),
    new PVector(390 + borderT, 10 + borderT, 0),
    new PVector(790, 10 + borderT, 0),
    new PVector(10 + borderT, 390, 0),
    new PVector(390 + borderT, 390, 0),
    new PVector(790, 390, 0)
  };

  public Ball(float x, float y, float r, color c) {
    this.pos = new PVector(x, y, 0);
    this.r = r;
    this.col = c;
  }

  void applyForce(PVector F) {
    a.add(F);
  }

  void move() {
    if (eaten) {
      return;
    }

    v.add(a);
    pos.add(v);
    v.x += v.x * friction;
    v.y += v.y * friction;

    if (abs(v.x) < 0.07) {
      v.x = 0;
    }
    if (abs(v.y) < 0.07) {
      v.y = 0;
    }

    if (pos.x < (r + borderT)) {
      pos.x = (r + borderT);
      v.x = -v.x;
    } else if (pos.x > width - (r + borderT)) {
      pos.x = width - (r + borderT);
      v.x = -v.x;
    }

    if (pos.y < (r + borderT)) {
      pos.y = (r + borderT);
      v.y = -v.y;
    } else if (pos.y > height - (r + borderT)) {
      pos.y = height - (r + borderT);
      v.y = -v.y;
    }

    for (PVector p : holesPos) {
      float d = dist(pos.x, pos.y, p.x, p.y);
      if (d < holeR) {
        if (abs(v.x) < 10 && abs(v.y) < 10) {
          eaten = true;
        }
      }
    }
  }

  void show() {
    if (eaten) {
      return;
    }

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(col);
    sphere(r);
    if (5 <= num && num <= 11 && col != #ffffff && col != #000000) {
      fill(255);
      sphere(r * 0.5);
    }
    fill(#000000);
    popMatrix();
  }

  boolean isMoving() {
    return (abs(v.x) >= 0.001 && abs(v.y) >= 0.001);
  }
}
