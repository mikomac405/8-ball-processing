ArrayList<PImage> ballsImgs = new ArrayList<PImage>();
ArrayList<Ball> balls = new ArrayList<Ball>();
Cue cue;
ArrayList<Pit> pits = new ArrayList<Pit>();
boolean resetCueBall;
boolean tookShot;
boolean ballInHand;
boolean endGame;

Player player1;
Player player2;
Player currentPlayer;

final float MIN_CUE_OFFSET = 10;      //minimalna i maksymalna odległość kija od białej kuli
final float MAX_CUE_OFFSET = 120;

final float STALE_BIAS = 0.07;    //dokładność przy sprawdzaniu, czy już nic się nie porusza

void setup() {
  size(1820, 980, P2D);
  imageMode(CENTER); // jakby bardzo w czymś przeszkadzało, to można zmienić
  loadGraphics();
  
  resetCueBall = false;
  tookShot = false;
  ballInHand = false;
  endGame = false;
  
  cue = new Cue();
  player1 = new Player("G1");
  player2 = new Player("G2");
  currentPlayer = player1;
  
  pits.add(new Pit(238,124));
  pits.add(new Pit(910,124));
  pits.add(new Pit(1582,124));
  pits.add(new Pit(238,856));
  pits.add(new Pit(910,856));
  pits.add(new Pit(1582,856));
  
  
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
 // balls = tempBalls;
  //balls[0].velocity = PVector.random2D().mult(30);
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
  
  for (int j = 0; j < balls.size(); j++) {
    balls.get(j).update();
    balls.get(j).display();
    balls.get(j).checkBoundaryCollision();
    for (int k = j + 1; k < balls.size(); k++)
      balls.get(j).handleCollision(balls.get(k));
    for (int l = 0; l < pits.size(); l++){
      if(balls.get(j).handlePitCollision(pits.get(l))){
          
          // Reset cue ball
        
          if(balls.get(j).number == 0){
            resetCueBall = true;
          } 
        
         if(currentPlayer.group == 0){
           if(balls.get(j).number < 8 && balls.get(j).number > 0){
             currentPlayer.group = 1;
             if(currentPlayer == player1){
               player2.group = 2;
             }
             else{
               player1.group = 2;
             }
           }
           else if(balls.get(j).number > 8 && balls.get(j).number <= 15){
             currentPlayer.group = 2;
             if(currentPlayer == player1){
               player2.group = 1;
             }
             else{
               player1.group = 1;
             }
           }
         }
         
         // Correct pocket
         
         if(currentPlayer.group == 1 && balls.get(j).number < 8 && balls.get(j).number > 0){
           currentPlayer.ballsInPits += 1;
         }
         else if(currentPlayer.group == 2 && balls.get(j).number > 8 && balls.get(j).number <= 15){
           currentPlayer.ballsInPits += 1;
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
         
         balls.remove(j);
         break;
        }
      }
    }
  
  
  for(int i = 0; i < pits.size(); i++){
    pits.get(i).draw();
  }
  
  if(checkStale(STALE_BIAS)){
    if(!cue.animationPlaying){
      if(tookShot){
        if(currentPlayer == player1){
          currentPlayer = player2;
        } else {
          currentPlayer = player1;
        }
        tookShot = false;
        ballInHand = false;
      }
      if(resetCueBall){
        balls.add(new Ball(500, 490, 20, ballsImgs.get(0), 0));
        resetCueBall = false;
        ballInHand = true;
      }
      cue.maxOffset = map(  // Zmiana odległości kija od kuli w zależności od dystansu kursora od kuli
        PVector.sub(getCueBall().position,new PVector(mouseX,mouseY)).mag(),
        0,width,
        MIN_CUE_OFFSET + getCueBall().radius,
        MAX_CUE_OFFSET + getCueBall().radius
      );
    }
    PVector temp = PVector.sub(getCueBall().position,new PVector(mouseX,mouseY)).normalize();
    cue.tipPosition = PVector.mult(temp, cue.offset).add(getCueBall().position);
    cue.endPosition = temp.mult(cue.offset + cue.length).add(getCueBall().position);
    
    cue.draw(); // tutaj odbywa się też próba odegrania animacji
    
    if(cue.trigger) // strzał w ostatniej klatce animacji
      getCueBall().velocity = new PVector(mouseX,mouseY).sub(getCueBall().position).mult(0.08);
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
  tookShot = true;
}

void keyPressed(){
  if(key == 'k'){
    if(ballInHand){
      getCueBall().position = new PVector(mouseX,mouseY);
    }
  }
}

void keyReleased(){
  if(key == 'k'){
    if(ballInHand){
      ballInHand = false;
    }
  }
}

Ball getCueBall(){
  int cueBallIndex = 0;
  for(int i = 0; i < balls.size(); i++){
    if(balls.get(i).number == 0){
      cueBallIndex = i;
    }
  }
  return balls.get(cueBallIndex);
}
