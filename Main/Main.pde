
ArrayList<PImage> ballsImgs = new ArrayList<PImage>();
Ball[] balls;
Cue cue;

final float MIN_CUE_OFFSET = 10;      //minimalna i maksymalna odległość kija od białej kuli
final float MAX_CUE_OFFSET = 120;

final float STALE_BIAS = 0.07;    //dokładność przy sprawdzaniu, czy już nic się nie porusza

void setup() {
  size(640, 360, P2D);
  imageMode(CENTER); // jakby bardzo w czymś przeszkadzało, to można zmienić
  loadGraphics();
  cue = new Cue();
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
  //balls[0].velocity = PVector.random2D().mult(30);
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
  
  if(checkStale(STALE_BIAS)){
    if(!cue.animationPlaying){
    cue.maxOffset = map(  // Zmiana odległości kija od kuli w zależności od dystansu kursora od kuli
      PVector.sub(balls[0].position,new PVector(mouseX,mouseY)).mag(),
      0,width,
      MIN_CUE_OFFSET + balls[0].radius,
      MAX_CUE_OFFSET + balls[0].radius
    );
    }
    PVector temp = PVector.sub(balls[0].position,new PVector(mouseX,mouseY)).normalize();
    cue.tipPosition = PVector.mult(temp, cue.offset).add(balls[0].position);
    cue.endPosition = temp.mult(cue.offset + cue.length).add(balls[0].position);
    
    cue.draw(); // tutaj odbywa się też próba odegrania animacji
    
    if(cue.trigger) // strzał w ostatniej klatce animacji
      balls[0].velocity = new PVector(mouseX,mouseY).sub(balls[0].position).mult(0.08);
  }
}

void loadGraphics(){
  ballsImgs = new ArrayList<PImage>();
  for(int i = 0; i < 16; i++)
    ballsImgs.add(loadImage("graphics/ball"+i+".png"));
}

boolean checkStale(float bias){
  float maxVel = 0;
  for(Ball ball : balls)
    if(ball.velocity.mag() > maxVel) 
      maxVel = ball.velocity.mag();
  return (maxVel < bias);
}

void mouseClicked(){
  if(checkStale(STALE_BIAS)) cue.playAnimation();  // uruchamia animację + triggeruje strzał na końcu
}
