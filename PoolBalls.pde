/*--------------------------------
  Date : 2023 - 2024
  Project : Pool
  contributors : -Tojotiana Cyriaque RAMAROSON
                 -Herilala RAKOTO
----------------------------------*/

import peasy.*;  

int H = 440;
int W = 840;
int numBalls = 16;
int borderT = 40;
float r = 15;
float holeR = 20;
Ball[] balls = new Ball[numBalls];
Hole[] holes = new Hole[6];
Border[] borders = new Border[4];
BorderDeco[] decos = new BorderDeco[4];

PVector wPos;
PVector cPos;
Stick stk;

PVector[] borderPos = {
  new PVector(0, 0),
  new PVector(W - borderT, 0),
  new PVector(0, 0),
  new PVector(0, H - borderT)
};

PVector[] decosPos = {
  new PVector(-10 , 70),
  new PVector(W + 20 - borderT, 70),
  new PVector(-40 , 0),
  new PVector(-40, H - borderT + 10),
};

PVector[] holesPos = {
  new PVector(10 + borderT, 10 + borderT),
  new PVector(H - 50 + borderT, 10 + borderT),
  new PVector(W - 50, 10 + borderT),
  new PVector(10 + borderT, H - 50),
  new PVector(H - 50 + borderT, H - 50),
  new PVector(W - 50, H - 50)
};

PeasyCam cam;

void setup() {
  ortho();
  size(840, 440, P3D);
  
  cam = new PeasyCam(this, width / 2, height / 2, 0, 500);

  ambientLight(50, 50, 50);
  directionalLight(255, 255, 255, 0, 0, -1);

 
  createBorders();
  createBorderDecos();
  createBalls();
  createHoles();
  stk = new Stick(r);
}

void keyPressed() {
  if (key == ' ') {
    stk.charge();
  }
}

void keyReleased() {
  if (key == ' ') {
    cPos.x = wPos.x;
    cPos.y = wPos.y;

    balls[15].v.x = -stk.l * cos(stk.angle);
    balls[15].v.y = -stk.l * sin(stk.angle);
    stk.hit();
  }
}

void draw() {
  background(180, 100, 40);
  handleCollision();
  
  directionalLight(255, 255, 255, 0, 0, -1);
  
  if (balls[15].eaten) {
    balls[15].eaten = false;
    balls[15].pos.x = random(r, width - r);
    balls[15].pos.y = random(r, height - r);
    balls[15].v = new PVector(0, 0, 0);
  }
  showPoolline();
  showBorders();
  showBorderDecos();
  
  showHoles();
  for (Ball ball : balls) {
    ball.show();
    ball.move();
  }
  wPos.x = balls[15].pos.x;
  wPos.y = balls[15].pos.y;
  
   
  if (!balls[15].isMoving()) {
    stk.show(wPos);
  } else {
    stk.show(cPos);
  }
  if(keyPressed){
    if (key == ' ') {
      stk.charge();
    }
  }
}

boolean collide(Ball b1, Ball b2) {
  if (b1.eaten || b2.eaten) {
    return false;
  }
  float minDist = b1.r + b2.r,
    dx = b1.pos.x - b2.pos.x,
    dy = b1.pos.y - b2.pos.y;
  float d = sqrt(dx * dx + dy * dy);

  return (d < minDist);
}

void removeOverlap(Ball b1, Ball b2, float angle) {
  float dx = b2.pos.x - b1.pos.x;
  float dy = b2.pos.y - b1.pos.y;
  float trueDist = b1.r + b2.r;

  float overX = trueDist * cos(angle) - dx;
  float overY = trueDist * sin(angle) - dy;

  b1.pos.x = b1.pos.x - overX;
  b1.pos.y = b1.pos.y - overY;

  b2.pos.x = b2.pos.x + overX;
  b2.pos.y = b2.pos.y + overY;
}

float collisionAngle(Ball b1, Ball b2) {
  float dx = b2.pos.x - b1.pos.x;
  float dy = b2.pos.y - b1.pos.y;
  return atan2(dy, dx);
}

void updateVel(Ball b1, Ball b2) {
  float v1x = b1.v.x, v1y = b1.v.y,
    v2x = b2.v.x, v2y = b2.v.y;
  float angle = collisionAngle(b1, b2);

  removeOverlap(b1, b2, angle);

  float v1xr = v1x * cos(angle) - v1y * sin(angle),
    v1yr = v1x * sin(angle) + v1y * cos(angle);

  float v2xr = v2x * cos(angle) - v2y * sin(angle),
    v2yr = v2x * sin(angle) + v2y * cos(angle);

  float v1xn = v2xr, v1yn = v1yr,
    v2xn = v1xr, v2yn = v2yr;

  float v1xf = v1xn * cos(angle) + v1yn * sin(angle),
    v1yf = v1yn * cos(angle) - v1xn * sin(angle);

  float v2xf = (v2xn * cos(angle) + v2yn * sin(angle)) * 0.7,
    v2yf = (v2yn * cos(angle) - v2xn * sin(angle)) * 0.7;

  b2.v = new PVector(v1xf, v1yf, 0);
  b1.v = new PVector(v2xf, v2yf, 0);
}

void handleCollision() {
  for (int i = 0; i < numBalls; i++) {
    for (int j = 0; j < numBalls; j++) {
      if (i != j && collide(balls[i], balls[j])) {
        updateVel(balls[i], balls[j]);
      }
    }
  }
}

void createBalls() {
  int yellow = 0;
  int red = 0;
  int black = 0;
  int white = 0;
  color c_yellow = #ffff00;
  color c_red = #ff0000;
  color c = #000000;
  int num = 1;
  for (int i = 0; i < numBalls; i++) {
    if (yellow < 7) {
      c = c_yellow;
      yellow++;
    } else if (red < 7) {
      c = c_red;
      red++;
    } else if (black == 0) {
      c = #000000;
      black++;
    } else if (white == 0) {
      c = #ffffff;
      white++;
    }
    balls[i] = new Ball(random(r + borderT, width - (r + borderT)), random(r + borderT, height - (r + borderT)), r, c);
    balls[i].num = num;
    num++;

    if (num == 16) {
      wPos = new PVector(balls[i].pos.x, balls[i].pos.y, 0);
      cPos = new PVector(wPos.x, wPos.y, 0);
    }
  }
}

void createHoles() {
  for (int i = 0; i < 6; i++) {
    holes[i] = new Hole(holesPos[i], holeR );
  }
}

void createBorderDecos() {
  decos[0] = new BorderDeco(decosPos[0] , borderT - 10 , H - 140);
  decos[1] = new BorderDeco(decosPos[1] , borderT - 10 , H - 140);
  decos[2] = new BorderDeco(decosPos[2] , W * 2 , borderT - 10);
  decos[3] = new BorderDeco(decosPos[3] , W * 2 , borderT - 10);
}

void showHoles() {
  for (Hole hole : holes) {
    hole.show();
  }
}

void createBorders() {
  borders[0] = new Border(borderPos[0], borderT, H + 10);
  borders[1] = new Border(borderPos[1], borderT, H + 10);
  borders[2] = new Border(borderPos[2], W + 10, borderT);
  borders[3] = new Border(borderPos[3], W + 10, borderT);
}

void showBorders() {
  for (Border border : borders) {
    border.show();
  }
}

void showBorderDecos(){    // this function adds decorations on the borders
  for (BorderDeco deco : decos) {
    deco.show();
  }
}
void showPoolline() {    // this function adds the green line
  stroke(0 , 100 , 0);
  strokeWeight(2);
  line((W / 4) + r , -20 , 0 , (W/4) + r , H, -20);
  strokeWeight(0);
}
