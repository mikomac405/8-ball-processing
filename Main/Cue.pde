class Cue{
  PVector tipPosition;
  
  Cue(Ball whiteBall){
      float x = whiteBall.position.x - whiteBall.radius*2;
      float y = whiteBall.position.y - 5;
      this.tipPosition = new PVector(x,y);
  }


  void display(){
      noStroke();
      rect(tipPosition.x, tipPosition.y, -300, 10);
  }
}
