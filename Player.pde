

class Player {

  int jumpTimer = 0;
  int flashTimer = 0;
  int ghostTimer = 0;
  int levitateTimer = 0; 
  int wallBusterTimer = 0; 
  int innerGhostTimer = 0;
  int innerLevitateTimer = 0;
  int antWidth = 100;
  int antHeight = 50;
  boolean flash, ghost, levitate;
  boolean flashActivated, ghostActivated, levitateActivated;
  boolean ghostReady, flashReady, doubleJumpReady, levitateReady; 
  boolean dead = false;
  boolean jumping = false;
  boolean checkWalls = true;
  boolean checkSpikes = true;
  boolean startTime = false;
  boolean [] collision = new boolean[2];
  float xvel, yvel, xAccel, yAccel, xpos, ypos;
  PImage doubleJumpReadyImage, flashReadyImage, ghostReadyImage, levitateReadyImage;
  PImage [] animation;



  Player(float xv, float yv, float xa, float ya, float xp, float yp)
  {
    smooth();
    xvel = xv;
    yvel = yv;
    xAccel = xa;
    yAccel = ya;
    xpos = xp;
    ypos = yp; 
    doubleJumpReadyImage = loadImage("doublejump.png");
    flashReadyImage = loadImage("flash.png");
    ghostReadyImage = loadImage("ghost.png");
    levitateReadyImage = loadImage("levitate.png");
  }

  void display()
  {
    antGif.loop();
    imageMode(CENTER);
    image(antGif, xpos, ypos, antWidth, antHeight);
  }

  void update()
  {

    yWallCollision();
    yWallCollision1();

    xvel = xvel + xAccel;
    yvel = yvel + yAccel;

    if (xvel >= 14)
      xvel = 14;

    if (ant.xpos <= 30000)
    {
      xpos = xpos + xvel;
      ypos = ypos + yvel;
    }

    controls(); 
    if (collision[0] || collision[1])
    {
      yvel = 0;
      ypos = 550 - antHeight/2;
    }
  }

  void drawPowerUpText() {
    if (doubleJumpReady)
    {
      image(doubleJumpReadyImage, 80, 75, 100, 50);
    }
    if (ghostReady)

    {
      image(ghostReadyImage, 260, 75, 100, 50);
    }

    if (flashReady)
    {
      image(flashReadyImage, 440, 75, 100, 50);
    }

    if (levitateReady)
    {      
      image(levitateReadyImage, 620, 75, 100, 50);
    }
  }

  void controls()
  {
    if (pressedKeys[32])
    {
      if (ypos + antHeight/2 >= 550)
      {
        ypos = ypos - 1;
        yvel = -8;
      }
    }
    if (jumpTimer >= 180)
    {
      doubleJumpReady = true;
      if ((pressedKeys[68]) || (pressedKeys[100]))
      {
        ypos = ypos - 1;
        yvel = -8;
        jumpTimer = 0;
        doubleJumpReady = false;
      }
    }
    jumpTimer++;

    if (flashTimer >= 300)
    {
      flashReady = true;

      if ((pressedKeys[70] || pressedKeys[102]))
      {
        ant.xvel = 150;
        flashTimer = 0;
        flash = true;
        flashReady = false;
      }
      flash = false;
    }
    flashTimer++;

    if (ghostTimer >= 180)
    {
      ghostReady = true;
      ghost = true;
    }

    if ((pressedKeys[71]) || (pressedKeys[103]) && ghost)
    {
      ghostTimer = 0;
      innerGhostTimer++;
      ghost = false;
      ghostReady = false;
    }

    if (innerGhostTimer > 0 && innerGhostTimer <= 120)
    {         
      checkWalls = false;
      innerGhostTimer++;
    }

    else
    {
      innerGhostTimer = 0;
      ant.checkWalls = true;
    }

    if (!ghost && ant.checkWalls)
    {
      ghostTimer++;
    }

    if (levitateTimer >= 240)
    {
      levitateReady = true;
      levitate = true;
    }

    if ( (pressedKeys[76]) || (pressedKeys[108]) && levitate )
    {
      levitateTimer = 0;
      innerLevitateTimer++;
      levitateReady = false;
      levitate = false;
    }
    if (innerLevitateTimer > 0 && innerLevitateTimer <= 120)
    {     
      ant.checkSpikes = false;
      innerLevitateTimer++;
    }
    else
    {
      innerLevitateTimer = 0;
      ant.checkSpikes = true;
    }

    if (!levitate && ant.checkSpikes)
    {
      levitateTimer++;
    }
  }




  boolean yWallCollision () {
    if (550 - (ant.ypos + antHeight/2) < 0)
    {
      collision[0] = true;
      //println(ant.ypos + antHeight/2);
    }
    else if ((550 - (ant.ypos + antHeight/2)) >= 0)
    {
      collision[0] = false;
      // println(ant.ypos + antHeight/2);
    }
    return collision[0];
  }

  boolean yWallCollision1 ()
  {
    if (ant.ypos - antHeight/2 <= 0)
    {
      collision[1] = true;
    }
    else if (ant.ypos - antHeight/2 > 0)
    {
      collision[1] = false;
    }
    return collision[1];
  }
}

