ArrayList<PImage> ballsImgs = new ArrayList<PImage>();
ArrayList<Ball> balls = new ArrayList<Ball>();
Cue cue;
ArrayList<Pit> pits = new ArrayList<Pit>();
boolean resetCueBall;
boolean tookShot;
boolean ballInHand;
boolean endGame;

boolean scored;

final int SIM_STEPS_PER_FRAME = 30;


Player player1;
Player player2;
Player currentPlayer;

final float MIN_CUE_OFFSET = 10;      //minimalna i maksymalna odległość kija od białej kuli
final float MAX_CUE_OFFSET = 120;

final float STALE_BIAS = 0.005;    //dokładność przy sprawdzaniu, czy już nic się nie porusza


final float GRAVITATIONAL_ACC = 9.807; // przyśpieszenie grawitacyjne
final float TABLE_FRICTION_COEFF = 0.105; // zakładamy średnią z rolling_resistance ~ 0.01 i sliding_friction ~0.2

final float PIXELS_PER_METER = 400;

void setup() {
  size(1820, 980, P2D);
  imageMode(CENTER); // jakby bardzo w czymś przeszkadzało, to można zmienić
  loadGraphics();
  frameRate(60);
  
  cue = new Cue();
  
  pits.add(new Pit(238,124));
  pits.add(new Pit(910,124));
  pits.add(new Pit(1582,124));
  pits.add(new Pit(238,856));
  pits.add(new Pit(910,856));
  pits.add(new Pit(1582,856));
  
  resetGame();
  
}

void draw() {
  
  if(endGame){
    return;
  }
  background(51);
  strokeWeight(0);
  fill(120, 38, 0);
  rect(200,86,1420,808, 28);
  fill(0, 245, 130);
  rect(238,124,1344,732);
  fill(0, 408, 612, 204);

  text(currentPlayer.toString(), 40, 240);
  text("Ball in hand: " + str(ballInHand), 40, 260);
  for(int i = 0; i < SIM_STEPS_PER_FRAME; i++){
    for (int j = 0; j < balls.size(); j++) {
      if(balls.get(j).inGame){
        balls.get(j).update();
        balls.get(j).checkBoundaryCollision();
        for (int k = j + 1; k < balls.size(); k++)
          if(balls.get(k).inGame) balls.get(j).handleCollision(balls.get(k));
        for (int l = 0; l < pits.size(); l++){
          if(balls.get(j).handlePitCollision(pits.get(l))){
          
            // Reset cue ball
        
            if(balls.get(j).number == 0){
              resetCueBall = true;
            } 
        
            if(currentPlayer.group == 0){
              if(balls.get(j).number < 8 && balls.get(j).number > 0){
                currentPlayer.group = 1;
                if(currentPlayer == player1) player2.group = 2;
                else player1.group = 2;
              }
              else if(balls.get(j).number > 8 && balls.get(j).number <= 15){
                currentPlayer.group = 2;
                if(currentPlayer == player1) player2.group = 1;
                else player1.group = 1;
              }
            }
         
            // Correct pocket
         
            if(currentPlayer.group == 1 && balls.get(j).number < 8 && balls.get(j).number > 0){
              currentPlayer.ballsInPits += 1;
              scored = true;
            }
            else if(currentPlayer.group == 2 && balls.get(j).number > 8 && balls.get(j).number <= 15){
              currentPlayer.ballsInPits += 1;
              scored = true;
            }
            else if(balls.get(j).number == 8 && currentPlayer.ballsInPits == 7){
              text(currentPlayer.name + " won!", 0, 240);
              endGame = true;
            }
         
            // Incorrect pocket
            if(currentPlayer.group == 1 && balls.get(j).number > 8 && balls.get(j).number <= 15){
              if(currentPlayer == player1){
                player2.ballsInPits += 1;
              } else {
                player1.ballsInPits += 1;
              }
              resetCueBall = true;
            }
            else if(currentPlayer.group == 2 && balls.get(j).number < 8 && balls.get(j).number > 0){
              if(currentPlayer == player1){
                player2.ballsInPits += 1;
              } else {
                player1.ballsInPits += 1;
              }
              resetCueBall = true;
            }
         
            // Fail
            if(balls.get(j).number == 8 && currentPlayer.ballsInPits != 7){
              if(currentPlayer == player1){
                text(player2.name + " won!", 10, 10);
              }
              else{
                text(player1.name + " won!", 10, 10);
              }
              endGame = true;
            }
            balls.get(j).inGame = false;
          }
        }
      }
    }
  }
  
  for(int i = 0; i < pits.size(); i++){
    pits.get(i).draw();
  }
  
  for(int i = 0; i < balls.size(); i++){
    if(balls.get(i).inGame) balls.get(i).display();
  }
  
  if(checkStale(STALE_BIAS)){
    if(!cue.animationPlaying){
      if(tookShot){
        if(!scored){
          if(currentPlayer == player1 ){
            currentPlayer = player2;
          } else {
            currentPlayer = player1;
          }
        }
        tookShot = false;
        scored = false;
        ballInHand = false;
      }
      if(resetCueBall){
        balls.get(0).position = new PVector(500, 490);
        balls.get(0).inGame = true;
        balls.get(0).velocity = new PVector(0,0);
        resetCueBall = false;
        ballInHand = true;
      }
      cue.maxOffset = map(  // Zmiana odległości kija od kuli w zależności od dystansu kursora od kuli
        PVector.sub(balls.get(0).position,new PVector(mouseX, mouseY)).mag(),
        0,width,
        MIN_CUE_OFFSET + balls.get(0).radius,
        MAX_CUE_OFFSET + balls.get(0).radius
      );
    }
    PVector temp = PVector.sub(balls.get(0).position,new PVector(mouseX, mouseY)).normalize();
    cue.tipPosition = PVector.mult(temp, cue.offset).add(balls.get(0).position);
    cue.endPosition = temp.mult(cue.offset + cue.length).add(balls.get(0).position);
    
    cue.draw(); // tutaj odbywa się też próba odegrania animacji
    
    if(cue.trigger){ // strzał w ostatniej klatce animacji
      float initialSpeed = map(cue.maxOffset,MIN_CUE_OFFSET + balls.get(0).radius,MAX_CUE_OFFSET + balls.get(0).radius,0.5,16); // m/s 
      balls.get(0).velocity = PVector.sub(balls.get(0).position,new PVector(mouseX, mouseY)).normalize().mult(-initialSpeed);
    }
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
    if(ball.velocity.mag() > maxVel && ball.inGame) 
      maxVel = ball.velocity.mag();
  return (maxVel < bias);
}

void mouseClicked(){
  if(checkStale(STALE_BIAS)) cue.playAnimation();  // uruchamia animację + triggeruje strzał na końcu
  tookShot = true;
}

void keyPressed(){
  if(key == 'k')
    if(ballInHand) balls.get(0).position = new PVector(mouseX, mouseY);
  if(key == 'r')
    resetGame();
}

void keyReleased(){
  if(key == 'k')
    if(ballInHand) ballInHand = false;
}

void resetGame(){
  resetCueBall = false;
  tookShot = false;
  ballInHand = false;
  endGame = false;
  scored = false;
  
  player1 = new Player("G1");
  player2 = new Player("G2");
  currentPlayer = player1;
  
  balls = new ArrayList<Ball>();
  balls.add(new Ball(500, 490, 20, ballsImgs.get(0), 0)); // cueBall
  balls.add(new Ball(1400, 410, 20, ballsImgs.get(12), 12)); // 12 stripes
  balls.add(new Ball(1400, 450, 20, ballsImgs.get(6), 6)); // 6 solid
  balls.add(new Ball(1400, 490, 20, ballsImgs.get(15), 15)); // 15 stripes
  balls.add(new Ball(1400, 530, 20, ballsImgs.get(13), 13)); // 13 stripes
  balls.add(new Ball(1400, 570, 20, ballsImgs.get(5), 5)); // 5 solid
  balls.add(new Ball(1365, 550, 20, ballsImgs.get(4), 4)); // 4 solid
  balls.add(new Ball(1365, 430, 20, ballsImgs.get(14), 14)); // 14 stripes
  balls.add(new Ball(1365, 470, 20, ballsImgs.get(7), 7)); // 7 solid
  balls.add(new Ball(1365, 510, 20, ballsImgs.get(11), 11)); // 11 stripes
  balls.add(new Ball(1330, 450, 20, ballsImgs.get(3), 3)); // 3 solid
  balls.add(new Ball(1330, 490, 20, ballsImgs.get(8), 8)); // 8 BLACK
  balls.add(new Ball(1330, 530, 20, ballsImgs.get(10), 10)); // 10 stripes
  balls.add(new Ball(1295, 470, 20, ballsImgs.get(2), 2)); // 2 solid
  balls.add(new Ball(1295, 510, 20, ballsImgs.get(9), 9)); // 9 stripes
  balls.add(new Ball(1260, 490, 20, ballsImgs.get(1), 1)); // 1 solid
}
