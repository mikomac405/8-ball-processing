
ArrayList<PImage> ballsImgs = new ArrayList<PImage>();
Ball[] balls;

void setup() {
  size(640, 360, P2D);
  imageMode(CENTER); // jakby bardzo w czymś przeszkadzało, to można zmienić
  loadGraphics();
  Ball[] tempBalls = { 
    new Ball(  0, 180, 20, ballsImgs.get(0)),
    new Ball(500, 100, 20, ballsImgs.get(12)), 
    new Ball(500, 140, 20, ballsImgs.get(6)),
    new Ball(500, 180, 20, ballsImgs.get(15)),
    new Ball(500, 220, 20, ballsImgs.get(13)),
    new Ball(500, 260, 20, ballsImgs.get(5)),
    new Ball(465, 120, 20, ballsImgs.get(4)),
    new Ball(465, 160, 20, ballsImgs.get(14)),
    new Ball(465, 200, 20, ballsImgs.get(7)),
    new Ball(465, 240, 20, ballsImgs.get(11)),
    new Ball(430, 140, 20, ballsImgs.get(3)),
    new Ball(430, 180, 20, ballsImgs.get(8)),
    new Ball(430, 220, 20, ballsImgs.get(10)),
    new Ball(395, 160, 20, ballsImgs.get(2)),
    new Ball(395, 200, 20, ballsImgs.get(9)),
    new Ball(360, 180, 20, ballsImgs.get(1)),
  };
  balls = tempBalls;
  balls[0].velocity = PVector.random2D().mult(30);
}

void draw() {
  background(51);
  for (int j = 0; j < balls.length; j++) {
    balls[j].update();
    balls[j].display();
    balls[j].checkBoundaryCollision();
    for (int k = j + 1; k < balls.length; k++)
      balls[j].handleCollision(balls[k]);
  }
}

void loadGraphics(){
  ballsImgs = new ArrayList<PImage>();
  for(int i = 0; i < 16; i++){
    ballsImgs.add(loadImage("graphics/ball"+i+".png"));
  }
}
