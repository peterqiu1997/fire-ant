class Spike
{

  boolean done = false;
  int numSpikeGaps; 
  int [] spikeXArray;
  int [] spikeWidthArray;
  int [] rightEdge;
  int spikeX;
  int spikeWidth;
  int jumpDistance = (int) ((2*(1000/35))*15)/10;
  Spike() 
  {    
    numSpikeGaps = 15;
    spikeXArray  = new int [numSpikeGaps];
    spikeWidthArray = new int [numSpikeGaps];
    rightEdge = new int [numSpikeGaps];
  }

  void createAndDisplay()
  {  
    for (int i = 0; i < numSpikeGaps; i++)
    {
      spikeWidthArray[i] = (int) random(100, jumpDistance);
      spikeXArray[i] = (int) random(1000, 30000);
    }
    grass.imageMode(CENTER);
    for (int j = 0; j < numSpikeGaps; j++)
    {
      rightEdge[j] = spikeXArray[j] + spikeWidthArray[j];
      for (int s = spikeXArray[j]; s < rightEdge[j]; s = s + 20)
      {      
        grass.tint(6, 124, 5);
        grass.image(spike, s, 60, 20, 35);
        grass.noTint();
      }
    }
    grass.imageMode(CORNER);
  }


  void checkCollisionWithPlayer() 
  {
    if (ant.checkSpikes)
    {
      for (int a = 0; a < numSpikeGaps; a++)
      {
        if (spikeXArray[a]<=ant.xpos && spikeXArray[a] + spikeWidthArray[a] >= ant.xpos && ant.ypos >= 500)  
        {      
          ant.dead = true;
        }
      }
    }
  }
}

