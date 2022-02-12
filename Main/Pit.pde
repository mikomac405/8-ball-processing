class Pit{
  PVector position;
  
  Pit(float x, float y){
    this.position = new PVector(x,y);
  }
  
  void draw(){
    fill(0);
    strokeWeight(0);
    ellipse(this.position.x, this.position.y,50,50);
  }
}
