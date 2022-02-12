class Ball {
  PVector position;
  PVector velocity = new PVector(0, 0);
  float deceleration = 0;
  
  PImage img;
  float radius;
  float dragCoeff = 0.02;
  int number;
  
  float mass = 0.16; // masa w kilogramach
  float pressureForce = this.mass * GRAVITATIONAL_ACC;  // siła nacisku na stół
  float frictionForce = TABLE_FRICTION_COEFF * this.pressureForce; //siła tarcia
  
  
  boolean inGame = true;

  Ball(float x, float y, float r_, PImage img, int number) {
    this.position = new PVector(x, y);
    this.radius = r_;
    this.img = img;
    this.number = number;
  }
 
  void update() {
    float deltaTime = 1.0 / (frameRate * SIM_STEPS_PER_FRAME);
    this.deceleration = this.frictionForce / this.mass;
    float inertia = this.frictionForce;
    PVector decelerationVector = PVector.mult(this.velocity, -1).normalize();
    PVector inertiaVector = PVector.mult(decelerationVector, -inertia * deltaTime);
    decelerationVector.mult(deceleration * deltaTime).add(inertiaVector);
    this.velocity.add(decelerationVector);
    if(this.velocity.mag() <= STALE_BIAS) this.velocity.mult(0);
    this.position.add(PVector.mult(this.velocity,deltaTime * PIXELS_PER_METER));
  }

  void checkBoundaryCollision() {
    boolean collision = false;
    if (position.x > 1582 - this.radius) {
      this.position.x = 1582 - this.radius;
      this.velocity.x *= -1;
      collision = true;
    } else if (this.position.x < 238 + this.radius) {
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
    return (distSquared <= sq(2 * this.radius));
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
