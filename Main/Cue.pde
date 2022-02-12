class Cue{
  PVector tipPosition = new PVector(0,0);
  PVector endPosition = new PVector(0,0);
  float length = 1000;  //to tak tylko domyślnie
  float maxOffset;
  float offset;
  boolean animationPlaying = false;
  float animationPercent = 0;
  boolean trigger = false;  //przyjmuje true tylko w ostatniej klatce animacji uderzenia
  
  void draw(){
    this.animate(0.1);
    stroke(20,30,20,160);
    strokeWeight(10);
    line(tipPosition.x, tipPosition.y, endPosition.x, endPosition.y);
  }
  
  void playAnimation(){
    this.animationPlaying = true;
    this.animationPercent = 0;
  }
  
  void animate(float speed){
    this.trigger = false;
    if(this.animationPercent >= 1){
       this.animationPercent = 0;
       this.animationPlaying = false;
       this.trigger = true;
    }else if(this.animationPlaying)
      this.animationPercent += speed;
    this.offset = map(this.animationPercent,0,1,this.maxOffset,MIN_CUE_OFFSET);
  }
}
