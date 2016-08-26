import java.util.*;
import ddf.minim.*;
import gifAnimation.*;
Gif antGif;
Gif smokeGif;

void setup() {
  size(800, 600);
  antGif = new Gif(this, "ant.gif");
  smokeGif = new Gif(this, "smoke.gif");
  //sound
  minim = new Minim(this);
  song = minim.loadFile("fish.mp3");
  menuSong = minim.loadFile("jupiter.mp3");
  f = loadFont("Harrington-36.vlw");
  stroke(5);
  textFont(f, 36);
  //create menus 
  main = new Menu(color(0), "FIRE ANT", "START", "INSTRUCTIONS", "CREDITS", 100, 250, 300, 350);
  instructionMenu = new Menu(color(0), 
  "INSTRUCTIONS", "A mischevious 10 year old with a magnifying glass is chasing you. There's nothing more to say. Space to jump, D to double jump, G to ghost through walls for 2 seconds, F to flash to maximum velocity, L to levitate and ignore spike collisions for 2 seconds.", 100, 250);
  creditsMenu = new Menu (color(0), "CREDITS", "By Peter Qiu and Eric Bonilla, Team FireRed. Songs: Jupiter in Blue - gillicuddy, Requiem for a Fish - The Freak Fandango Orchestra. Credit to FreeIconArchives for the gem icons.    Menu and Level backgrounds are forest backgrounds made by Shayphis of Newgrounds.", 100, 250);
  //create player
  ant = new Player(0, 0, 0.75, 0.5, 200, 550);
  levelSpikes = new Spike();
  levelSmoke = new Smoke(0, 0, 1, 0, 50, 550);
  //images
  //levelSpikes.createAndDisplay();

  spike = loadImage("spike.png");
  grassTile = loadImage("grass.png");
  menuBG = loadImage("menuBG.png");
  levelBG = loadImage("levelBG2.png");
  anthill = loadImage("anthill.png");
  grass = createGraphics(30500, 150, JAVA2D);
  grass.beginDraw();
  grass.background(0, 0, 0, 0);
  levelSpikes.createAndDisplay();
  for (int c = 0; c <= 30500; c = c + 100)
  {
    grass.image(grassTile, c, 50, 100, 200);
  }

  grass.endDraw();
  for (int i = 0; i < 15; i++)
  {
    levelGems.add(new Gem( (int) random(300, 30000), 515 ) );
  }
}

Menu main, instructionMenu, creditsMenu;
Player ant;
Smoke levelSmoke;
Spike levelSpikes;
Minim minim;
AudioPlayer song, loseSong, winSong, menuSong;
PFont f;
PImage grassTile, menuBG, levelBG, spike, anthill;
PGraphics grass;
ArrayList <Gem> levelGems = new ArrayList<Gem>();
ArrayList <Ledge> levelLedges = new ArrayList<Ledge>();
boolean [] collidedWithGem = new boolean[15];
int numGemsHit = 0;
float count = 0;
float start = 4.5;
float xtranslate, ytranslate;
int scoreTimer = 0;
int menuSelection = 1;
int score = 0;
int rate = 60;
int finalScore;
boolean showMenuBG = true;
boolean go = false;
boolean scoreShow = false;
boolean doneWithGame = false;
boolean mouseclick, iMenuShowing, cMenuShowing;
boolean[] pressedKeys = new boolean[256];
boolean[] numGemsHitArray = new boolean[15];
int multiplier;
int timer = 0;
Wall wall = new Wall();
float bgX = 0;



void drawWorld() {

  wall.create();
  levelSmoke.update();
  levelSmoke.display();
  levelSmoke.checkCollisionWithPlayer();
  image(grass, 0, 450);
  image(anthill, 30000, 400, 400, 300);
}

void showScore() {
  if (scoreShow)
  {
    textFont(f, 16);
    fill(255);
    text("Score: " + (finalScore), width - 50, 15);
  }
}

void draw() {
  println(frameRate);
  imageMode(CORNER);
  image(menuBG, 0, 0);
  boolean currentlyPlayingGame = go && ant.xpos <= 30000 && !ant.dead;

  // Draw the game UI

  if (currentlyPlayingGame) {

    image(levelBG, (int)bgX, 0);
    bgX-=.35;
    score++;
    scoreTimer = scoreTimer + 1;
    ant.drawPowerUpText();
    showScore();
  }


  translate(-xtranslate, -ytranslate);

  if (menuSelection == 0)
  {
    song.play();
    menuSong.pause();
    count = count + 1;
    iMenuShowing = false;
    cMenuShowing = false;
    Countdown();
    if (currentlyPlayingGame)
    {
      drawWorld();
      for (int a = 0; a < levelGems.size(); a++)
      {
        if (collidedWithGem[a])
        {
          levelGems.get(a).poof();
          levelGems.get(a).hit = true;
        }
      }



      for (int j = 0; j < levelGems.size(); j++) 
      {
        levelGems.get(j).display();
        if (ant.xpos + 50 >= levelGems.get(j).gemX && ant.xpos < levelGems.get(j).gemX && ant.ypos <=levelGems.get(j).gemY + 25 && ant.ypos >=levelGems.get(j).gemY - 25)
        {
          collidedWithGem[j] = true;
        }
      }

      ant.update();      
      levelSpikes.checkCollisionWithPlayer();   
      ant.display(); 
      if (ant.xvel > 1)
      {
        finalScore = score/10;
      }
      showProgress();
      if ((ant.xpos < width/2 + xtranslate)) 
      {
        scoreShow = true;
      }
      else 
      {
        scoreShow = true;
        xtranslate = xtranslate + ant.xvel;
      }
      wall.checkCollisionWithPlayer();
    }

    else if (ant.dead)
    {
      for (int y = 0; y < 15; y++)
      {
        if (levelGems.get(y).hit)
        {
          numGemsHit = numGemsHit + 1;
          levelGems.get(y).hit = false;
        }
      }
      int gemScore = numGemsHit*10;
      int totalScore = gemScore + finalScore - scoreTimer/15;
      textFont(f, 36);
      fill(0);
      textAlign(CENTER);
      text("YOU LOSE.", width/2 + xtranslate, height/2 - 72);
      text("SAD LIFE.", width/2 + xtranslate, height/2);   
      text("MAIN MENU", width/2 + xtranslate, height/2 + 108);
      // rect(301 + xtranslate, height/2 + 72, 198, 36);
      noFill();
      if (mouseX >= 301 && mouseX <= 499 && mouseY >=  height/2 + 72 && mouseY <= height/2 + 108)
      {
        if (mouseclick)
        {
          restart();
          menuSelection = 1;
        }
      }      
      fill(0, 255, 74);
      textFont(f, 16);
      text("Base Score: " + (finalScore) + " Gem Score: " + gemScore + " Time Penalty: " + scoreTimer/15 + " Total Score: " + totalScore, width/2 + xtranslate, height/2 + 36);
      textFont(f, 36);
      noFill();
    }

    if (ant.xpos >= 30000)
    {
      for (int y = 0; y < 15; y++)
      {
        if (levelGems.get(y).hit)
        {
          numGemsHit = numGemsHit + 1;
          levelGems.get(y).hit = false;
        }
      }
      int gemScore = numGemsHit*10;
      int totalScore = gemScore + finalScore;
      textFont(f, 36);
      fill(0);
      textAlign(CENTER);
      text("YOU WIN!", width/2 + xtranslate, height/2 - 72);
      text("MAIN MENU", width/2 + xtranslate, height/2 + 108);
      noFill();
      if (mouseX >= 301 && mouseX <= 499 && mouseY >=  height/2 + 72 && mouseY <= height/2 + 108)
      {
        if (mouseclick)
        {
          restart();
          menuSelection = 1;
        }
      } 
      noFill();
      fill(0, 255, 74);
      textFont(f, 16);
      text("Base Score: " + (finalScore) + " Gem Score: " + gemScore + " Time Penalty: " + scoreTimer/10 + " Total Score: " + totalScore, width/2 + xtranslate, height/2 + 36);
      textFont(f, 36);
      noFill();
    }
  }

  if (menuSelection == 1)
  {
    main.display();
    menuSong.play();
  }

  if (menuSelection == 2)
  {
    iMenuShowing = true;
    cMenuShowing = false;
    instructionMenu.displaySubMenu();
  }

  if (menuSelection == 3)
  {
    iMenuShowing = false;
    cMenuShowing = true;
    creditsMenu.displaySubMenu();
  }

  if (menuSelection==1) 
  {

    if (mouseX >= 329 && mouseX <= 468 && mouseY <= 350 && mouseY >= 314)
    {

      if (mouseclick)
        menuSelection = 3;
    }

    if (mouseX >= 344 && mouseX <=456 && mouseY <= 250 && mouseY >= 214)
    {

      if (mouseclick)
        menuSelection = 0;
    }

    if (mouseX >= 280 && mouseX <= 518 && mouseY <= 300 && mouseY >= 264)
    {

      if (mouseclick)
        menuSelection = 2;
    }
  }



  if (mouseX >=55 && mouseX <= 150 && mouseY >= 464 && mouseY <=500 && (cMenuShowing || iMenuShowing))
  {
    if (mouseclick)
      menuSelection = 1;
  }

  mouseclick = false;
}




void keyPressed() {
  if (key < 256)
    pressedKeys[key] = true;
}

void keyReleased() {
  if (key < 256)
    pressedKeys[key] = false;
}


void mouseClicked() {
  mouseclick = true;
}

void Countdown() {
  fill(color(0));
  textFont(f, 36);
  if (count/rate < 1) {
    text("3", width/2, height/2);
  }
  else if (count/rate >= 1 && count/rate < 2) {
    text("2", width/2, height/2);
  }
  else if (count/rate >= 2 && count/rate < 3) {
    text("1", width/2, height/2);
  }
  else if (count/rate >= 3 && count/rate < start) {
    textAlign(CENTER);
    textFont(f, 36);
    text("Go!", width/2, height/2);
    go = true;
  }
  noFill();
}

void showProgress() 
{
  if (ant.xpos <= 30000 && !ant.dead)
  {
    color playerProgressCol = color(51, 177, 242);
    color smokeProgressCol = color( 41, 59, 49);
    float smokeProgressY = 15;
    float playerProgressY = 15;
    float playerProgressX = map(ant.xpos, 0, 30000, 0, 700) + xtranslate;
    float smokeProgressX = map(levelSmoke.xpos, 0, 30000, 0, 700) + xtranslate;
    stroke(255);
    line(xtranslate, 15, 700 + xtranslate, 15);
    noStroke();
    fill(playerProgressCol);
    ellipse(playerProgressX, playerProgressY, 20, 20);
    noFill();
    fill(smokeProgressCol);
    ellipse(smokeProgressX, smokeProgressY, 20, 20);
    noFill();
  }
}
void restart() {
  song.pause();
  song = minim.loadFile("fish.mp3");
  menuSong = minim.loadFile("jupiter.mp3");
  main = new Menu(color(0), "FIRE ANT", "START", "INSTRUCTIONS", "CREDITS", 100, 250, 300, 350);
  instructionMenu = new Menu
    (color(0), 
  "INSTRUCTIONS", "A mischevious 10 year old with a magnifying glass is chasing you. There's nothing more to say. Space to jump, D to double jump, G to ghost through walls for 2 seconds, F to flash to maximum velocity, L to levitate and ignore spike collisions for 2 seconds.", 100, 250);
  creditsMenu = new Menu (color(0), "CREDITS", "By Peter Qiu and Eric Bonilla, Team FireRed. Songs: Jupiter in Blue - gillicuddy, Requiem for a Fish - The Freak Fandango Orchestra. Credit to FreeIconArchives for the gem icons.  Menu and Level backgrounds are forest backgrounds made by Shayphis of Newgrounds", 100, 250);
  ant = new Player(0, 0, 0.75, 0.5, 200, 550);
  levelSpikes = new Spike();
  levelSmoke = new Smoke(0, 0, 1, 0, 50, 450);
  levelGems = new ArrayList<Gem>();
  for ( int i = 0; i < 15; i++)
  {
    levelGems.add(new Gem( (int) random(300, 30000), 475 ) );
  }
  collidedWithGem = new boolean[15];
  numGemsHit = 0;
  count = 0;
  start = 4.5;
  xtranslate = 0;
  ytranslate = 0;
  scoreTimer = 0;
  menuSelection = 1;
  score = 0;
  rate = 60;
  finalScore = 0;
  showMenuBG = true;
  go = false;
  scoreShow = false;
  doneWithGame = false;
  boolean mouseclick, iMenuShowing, cMenuShowing;
  pressedKeys = new boolean[256];
  numGemsHitArray = new boolean[15];
  multiplier = 1;
  timer = 0;
  wall = new Wall();
  bgX = 0;
  grass = createGraphics(30500, 150, JAVA2D);
  grass.beginDraw();
  grass.background(0, 0, 0, 0);
  levelSpikes.createAndDisplay();
  for (int c = 0; c <= 30500; c = c + 100)
  {
    grass.image(grassTile, c, 50, 100, 200);
  }
  grass.endDraw();
}

