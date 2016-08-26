class Smoke {

  float xvel, yvel, xAccel, yAccel, xpos, ypos;
  PImage [] smokeAnimation;
  float smokeWidth, smokeHeight;


  Smoke(float xv, float yv, float xa, float ya, float xp, float yp) {
    smooth();
    xvel = xv;
    yvel = yv;
    xAccel = xa;
    yAccel = ya;
    xpos = xp;
    ypos = yp; 
    smokeWidth = 40;
    smokeHeight = 105;
  }

  void display()
  {
    if (ant.xpos > 8500) {
      smokeGif.loop();
      imageMode(CENTER);
      image(smokeGif, (int) xpos, (int) ypos, smokeWidth, smokeHeight); 
      displayLight();
      imageMode(CORNER);
    }
  }

  void displayLight() {

    fill(255, 255, 150, 50);
    triangle(xpos, ypos, xpos, -20, xpos - 10, -100);
    noFill();
  }

  void update() 

  {
    if (ant.xpos > 8500)
    {
      xvel = xvel + xAccel;
      yvel = yvel + yAccel;
    }
    if (xvel >= 17)
      xvel = 17;
    if (ant.xpos < 30000)
    {
      xpos = xpos + xvel;
      ypos = ypos + yvel;
    }

    if (xpos > 30000)
      xpos = 30000;
  }

  void checkCollisionWithPlayer() {
    if (levelSmoke.xpos >= ant.xpos - 20 && levelSmoke.xpos <= ant.xpos + 20)
    {
      ant.dead = true;
    }
  }
}

