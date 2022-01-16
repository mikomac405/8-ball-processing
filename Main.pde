Ball[] balls =  { 
  new Ball(100, 400, 20, color(255,0,0)), 
  new Ball(100, 200, 20, color(0,0,0)),
  new Ball(100, 300, 20, color(255,255,255)),
  new Ball(700, 400, 20, color(255,255,0)),
  new Ball(700, 200, 20, color(0,255,0)),
  new Ball(700, 300, 20, color(0,0,255)),
};

void setup() {
  size(640, 360);
}

void draw() {
  background(51);

  for (Ball b : balls) {
    b.update();
    b.display();
    b.checkBoundaryCollision();
    for(Ball b_collide: balls){
      if(b != b_collide){
        b.checkCollision(b_collide);
      }
    }
  }
  
 // balls[0].checkCollision(balls[1]);
}