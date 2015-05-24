class Ball {
  PVector location;
  PVector velocity;

  color ballColor;
  float ballRadius = 20;


  Ball(PVector loc, float r, color c) {
    ballRadius = r;
    ballColor = c;
    location = loc;

    PVector mouse = new PVector(mouseX, mouseY); 
    mouse.sub(location);
    velocity = mouse;
    velocity.setMag(40/(ballRadius));
    velocity.limit(10);
  }

  void display() {
    pushStyle();
    fill(ballColor);
    noStroke();
    ellipse(location.x, location.y, ballRadius*2, ballRadius*2);
    popStyle();
  }

  void move() {
    location.add(velocity);
  }
  
 
}