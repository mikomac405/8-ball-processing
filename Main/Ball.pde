class Ball {
  PVector position;
  PVector velocity = new PVector(0,0);
  
  PImage img;
  float radius;
  float dragCoeff = 0.02;
  int number;

  Ball(float x, float y, float r_, PImage img, int number) {
    this.position = new PVector(x, y);
    this.radius = r_;
    this.img = img;
    this.number = number;
  }
 
  void update() {
    this.position.add(this.velocity.mult(1-this.dragCoeff));
  }

  void checkBoundaryCollision() {
    boolean collision = false;
    if (position.x > 1582 - this.radius) {
      this.position.x = 1582 - this.radius;
      this.velocity.x *= -1;
      collision = true;
    } else if (this.position.x < 238+this.radius) {
      this.position.x = 238+this.radius;
      this.velocity.x *= -1;
      collision = true;
    } else if (this.position.y > 856 - this.radius) {
      this.position.y = 856 - this.radius;
      this.velocity.y *= -1;
      collision = true;
    } else if (this.position.y < 124 + this.radius) { // this.radius
      this.position.y = 124 + this.radius;
      this.velocity.y *= -1;
      collision = true;
    }
    if(collision) this.velocity.mult(1 - 4 * this.dragCoeff);
  }
  
  boolean handlePitCollision(Pit pit){
    PVector distVec = PVector.sub(this.position, pit.position);
    float distSquared = sq(distVec.x) + sq(distVec.y);
    if(distSquared <= sq(2 * this.radius)) {
      return true;
    }
    return false;
  }
  
  void handleCollision(Ball other) {
    PVector distVec = PVector.sub(this.position, other.position);
    float distSquared = sq(distVec.x) + sq(distVec.y);
    if(distSquared <= sq(2 * this.radius)) {
      PVector velocityDiff = PVector.sub(other.velocity, this.velocity);
      float dotProduct = PVector.dot(distVec, velocityDiff);
      if(dotProduct > 0) {
        float collisionScale = dotProduct / distSquared;
        PVector delta = distVec.mult(collisionScale);
        this.velocity.add(delta);
        other.velocity.sub(delta);
      }
    }
  }
  
  void display() {
    image(this.img, this.position.x, this.position.y, this.radius*2, this.radius*2);
  } 
}
