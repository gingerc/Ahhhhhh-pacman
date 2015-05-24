class Player {
  color playerColor;
  color mouthColor;
  float maxPlayerDiameter = 100;
  float minPlayerDiameter = 80;
  float maxMouthDiameter = 80;
  float minMouthDiameter = 0;
  float playerDiameter = minPlayerDiameter;
  float mouthDiameter = 50;

  PVector location;


  //Boolean lastOpened = false;
  //float minDuration = 1000;
  //float lastOpenedMouth = 0;
  Boolean opened = false;

  Player() {
    location = new PVector(mouseX, mouseY);

    playerColor = color(#6AC4A1);
    mouthColor = color(255, 100);
  }

  void display() {
    pushStyle();
    noStroke();
    fill(playerColor);
    ellipse(location.x, location.y, playerDiameter, playerDiameter);
    fill(mouthColor);
    stroke(255);
    strokeWeight(3);
    ellipse(location.x, location.y, mouthDiameter, mouthDiameter);
    popStyle();
  }

  void move() {
    location.x = mouseX;
    location.y = mouseY;
    
    opened = rms.analyze() > 0.1;
    //if (opened != lastOpened && millis() > lastOpenedMouth+minDuration) {
    // opened = lastOpened;
    // lastOpenedMouth = millis();
    //}
    
    float speed = 3;
    if (!opened) { // normal
      // mouthDiameter -> 0  
      mouthDiameter = max(minMouthDiameter, mouthDiameter-speed);
      playerDiameter = max(minPlayerDiameter, playerDiameter-speed);
    } else { // open mouth
      // mouthDiameter -> max -> oscillate
      // player -> max
      if (mouthDiameter >= maxMouthDiameter) {
        // oscillate
        mouthDiameter = maxMouthDiameter+10*sin(millis());
      } else {
         mouthDiameter = min(maxMouthDiameter, mouthDiameter+speed);
      }
      
      playerDiameter = min(maxPlayerDiameter, playerDiameter+speed);
    }
  }
  
  Boolean collision(Ball b) {
    PVector distance = location.get();
    distance.sub(b.location);
    if (distance.mag() <= b.ballRadius + playerDiameter/2) {
      return true;
    }
    return false;
  }
}