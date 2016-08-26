class Wall {
  int [] wallXArray;
  color [] wallColorArray;
  int wallWidth = 10;
  int wallHeight = 60;
  int numWalls = 20;
  int wallSpacing = 30; 
  float wallAlpha = 255;
  color wallColor;
  boolean doneWithWalls = false;


  Wall()
  {
    wallXArray = new int[numWalls];
    wallColorArray = new color[numWalls];
    wallColor = color(72, 141, 214);
  }

  void create() {
    for (int i = 0; i < numWalls; i++)
    {
      if (!doneWithWalls)
      {
        wallColorArray[i] = wallColor;
        wallXArray[i] = (int) random(600, 30000);
        if (i == numWalls - 1)
          doneWithWalls = true;
      }
      else
      {
        for (int k = 0; k < numWalls; k++)
        {
          fill(wallColorArray[k]);
          rect(wallXArray[k], 490, wallWidth, wallHeight);
        }
      }
    }
  }


  void checkCollisionWithPlayer() 
  {

    if (ant.checkWalls)
    {

      for (int a = 0; a < numWalls; a++)
      {
        if (ant.xpos + ant.antWidth/2 >= wallXArray[a] && ant.xpos + ant.antWidth/2 <= wallXArray[a] + 15 && ant.ypos >= 490)
        {
          ant.xvel = 0;
          wallColorArray[a] = color(255, 255, 255, 0);
        }
      }
    }
  }
}

