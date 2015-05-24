//player
import processing.sound.*;
AudioIn in;
Amplitude rms;

PFont A;

PImage startScreen;
PShape endScreen;

// player
Player player;

//Array of balls
ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Ball> stickedBalls = new ArrayList<Ball>();
color[] c;

//controling balls' birth
float lastFired = 0;
float numBallsPerSec = 5;

//scene
int scene = 0;
float lastStarted = 0;

void setup() {
  size(1280, 720);

  A=createFont("DAYPBL__.ttf", 60);
  textFont(A);

  noStroke();
  //Audio Input
  in=new AudioIn(this, 0);
  in.start();
  rms=new Amplitude(this);
  rms.input(in);
  //start and end
  startScreen = loadImage("start.png");
  endScreen = loadShape("end.svg");
  //initiate player circle
  player = new Player(); 
  // assign different colors to balls
  c= new color[] {color(#F9C0AF), color(#F1EF9C), color(#F59AA4), color(#C2C8E5), color(#AEDDD8)};
}


void draw() {
  background(255);

  if (scene == 0) {
    startScreen();
  } else if (scene == 1) {
    noCursor();
    //timer for firing balls 5/sec
    float interval = 1000/numBallsPerSec;
    if (lastFired+interval < millis()) {
      createBall();
      lastFired = millis();
    }

    //draw balls 
    ArrayList<Ball> ballsToBeRemoved = new ArrayList<Ball>();  
    ArrayList<Ball> ballsToBeEaten = new ArrayList<Ball>(); 

    for (Ball b : balls) {
      b.display();
      b.move();

      int offset = 100;
      if ( b.location.x < -offset || b.location.x > width +offset ||
        b.location.y < -offset || b.location.y > height +offset) {
        ballsToBeRemoved.add(b);
      } else if (player.collision(b)) {
        if (player.opened) {
          ballsToBeEaten.add(b);
        } else {
          lastScore = ballsEaten()+eclapsedTime();
          scene = 2;
        }
      }
    }
    balls.removeAll(ballsToBeRemoved);
    balls.removeAll(ballsToBeEaten);

    stickedBalls.addAll(ballsToBeEaten);
    for (Ball b : stickedBalls) {
      //PVector player.location
      //b.velocity.sub()
    }

    //draw player circle
    player.move();
    player.display();
    
    // draw time and ballsEaten
    pushStyle();
    fill(#6AC4A1);
    textSize(20);
    text("Time: "+String.format("%.1f", eclapsedTime()), 50, 50);
    text("Balls Eaten: "+ballsEaten(), 200, 50);
    popStyle();
  } else if (scene == 2) {
    endScreen();
  }
}


void createBall() {
  float maxBallRaidus = 50;
  PVector location ;

  int edge = int(random(0, 4));
  if (edge == 0) {
    location = new PVector(random(width), -maxBallRaidus);
  } else if (edge == 1) {
    location = new PVector(width+maxBallRaidus, random(height));
  } else if (edge == 2) {
    location = new PVector(random(width), height+maxBallRaidus);
  } else { 
    location = new PVector(-maxBallRaidus, random(height));
  }

  balls.add(new Ball(location, random(10, 30), c[int(random(0, 5))]));
}

void startScreen() {
  imageMode(CENTER);
  image(startScreen, 640, 360);
}

float lastScore = 0;
void endScreen() {
  cursor();
  shape(endScreen, 250, 40);
  String gameover = "GAME OVER";
  String scoreString = "Score: "+String.format("%.1f", lastScore);
  text(gameover, 470, 150); 
  text(scoreString, 500, 250);
}

int ballsEaten() {
  return stickedBalls.size();
}

float eclapsedTime() {
  return (millis()-lastStarted)/1000;
}

void mouseClicked() {
  Boolean next = false;
  if (scene == 0) {
    if (mouseX> 583 && mouseX <734 && mouseY >356 && mouseY < 507) {
      next = true;
      lastStarted = millis();
    }
  } else if (scene == 1) {
  } else if (scene == 2) {
    next = (mouseX> 616 && mouseX <712 && mouseY >300 && mouseY < 395);
  }


  if (next == true) {
    scene ++;
    if (scene == 3) {
      scene = 1;
      lastStarted = millis();
      balls.clear();
      stickedBalls.clear();
    }
  }
}