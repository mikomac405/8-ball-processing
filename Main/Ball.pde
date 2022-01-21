class Ball {
  PVector position;
  PVector velocity;
  
  color clr;
  float radius;
  float dragCoeff = 0.01;

  Ball(float x, float y, float r_, color c) {
    this.position = new PVector(x, y);
    this.radius = r_;
    this.clr = c;
    if(this.clr == color(255,255,255)) this.velocity = PVector.random2D().mult(20);
    else this.velocity = new PVector(0,0);
  }

  void update() {
    this.position.add(this.velocity.mult(1-this.dragCoeff));
  }

  void checkBoundaryCollision() {
    boolean collision = false;
    if (position.x > width - this.radius) {
      this.position.x = width - this.radius;
      this.velocity.x *= -1;
      collision = true;
    } else if (this.position.x < this.radius) {
      this.position.x = this.radius;
      this.velocity.x *= -1;
      collision = true;
    } else if (this.position.y > height - this.radius) {
      this.position.y = height - this.radius;
      this.velocity.y *= -1;
      collision = true;
    } else if (this.position.y < this.radius) {
      this.position.y = this.radius;
      this.velocity.y *= -1;
      collision = true;
    }
    if(collision) this.velocity.mult(1 - 4 * this.dragCoeff);
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
    noStroke();
    fill(clr);
    ellipse(position.x, position.y, radius*2, radius*2);
  }
}
