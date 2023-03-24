import processing.serial.*;
import processing.sound.*;
int seconds = 0;
Serial myPort;
byte cVal;
boolean changedState;
Player[] Players = new Player[5];
PFont font;
PImage miningBackground, upgradeBackground, up, down;
float oilPrice;
IntList list = new IntList();
int lastTime, lastTimeSold;
float lastPrice;
float soldBuffer;
float sellInfluence = 0.5;
boolean[] playerSold = new boolean[5];
float tempDelta;
int sign = 1;
float sellDelta;
int sellCounter;
float a1, a2, a3, b1, b2, b3, c1, c2, c3;

String winner;
float landPrice;
boolean won;

boolean playingSound;
SoundFile sound;

float X =0;

int year = 2;
int leap = 1;
int timeLimit = 365;
String gameState = "upgrade";
int startTime;
void setup() {


  frameRate(30);

  sound = new SoundFile(this, "Turmoil OST - 07 - Oil Spill Hoedown.mp3");
  for (int i = 0; i < 5; i++) {
    list.append(0);
  }
  list.shuffle();

  //   String portName = Serial.list()[0];
  //  myPort = new Serial(this, portName, 9600);

  font = createFont("WesternBangBang-Regular.ttf", 80);
  textFont(font);
  fullScreen();
  size(1920, 1080);


  String[] inputLines = loadStrings("save.txt");

  String[][] lines = new String[inputLines.length][3];

  for (int i = 0; i < inputLines.length; i ++) {

    lines[i] = split(inputLines[i], ' ');
  }
  Players[0] = new Player("Červení", 0, list.get(0));
  Players[1] = new Player("Oranžoví", 375, list.get(1));
  Players[2] = new Player("Žlutí", 2*375, list.get(2));
  Players[3] = new Player("Zelení", 3*375, list.get(3));
  Players[4] = new Player("Modří", 4*375, list.get(4));

  for (int i = 0; i < Players.length; i++) {
    //Players[i].loadStats(lines);
    Players[i].initializeStats();
    Players[i].loadImages();
  }
  miningBackground = loadImage("background/background-rev2.png");
  upgradeBackground = loadImage("background/upgrades-3.png");
  up = loadImage("background/arrow-up.png");
  down = loadImage("background/arrow-down.png");
}



void draw() {

  seconds();
  ///////////////////////////////////////////////////////////////////MINING
  if (gameState.equals("mining")) {
    setButtons();
    //background(255);
    image(miningBackground, 0, 0);
    fill(0);
    textSize(80);
    textAlign(CENTER, CENTER);
    text(date(seconds), 210, 195);
    textSize(60);
    text(year + 1860, 210, 260);
    setButtons();

    for (int i = 0; i < Players.length; i++) {


      Players[i].mining(seconds);
      //Players[i].upgrade();
      Players[i].showUpgrades();
      Players[i].showMining();
      Players[i].timers(seconds);
      Players[i].sell(oilPrice);
    }

    oilPrice(year);
    soldBuffer();

    //savePlayers();
    if (keyPressed) {
      if (key == ' '){
        Players[0].buttonPressed = true;
      Players[1].buttonPressed = true;
      Players[2].buttonPressed = true;
      Players[3].buttonPressed = true;
Players[4].buttonPressed = true;}
    } else{
      Players[0].buttonPressed = false;
        Players[1].buttonPressed = false;
      Players[2].buttonPressed = false;
      Players[3].buttonPressed = false;
Players[4].buttonPressed = false;}
  }
  ///////////////////////////////////////////////////////////////////UPGRADE

  if (gameState.equals("upgrade")) {


    imageMode(CORNER);
    image(upgradeBackground, 0, 0);
    fill(0);

    for (int i = 0; i < Players.length; i++) {
      Players[i].upgrade();
      Players[i].showUpgrades();
    }
  }
  ///////////////////////////////////////////////////////////////////WIN

  if (gameState.equals("final"))
    showFinal();

  ///////////////////////////////////////////////////////////////////LAND
  if (gameState.equals("auction")) {
    estate();
  }
  ///////////////////////////////////////////////////////////////////TEST
  if (gameState.equals("test")) {
    setButtons();
    test();
  }
}

void keyPressed () {
  if (!changedState);
  if (key == '\n')
    switchState();
}
void keyReleased() {
  changedState = false;
}

void switchState() {

  if (gameState.equals("upgrade"))
    beginMining();

  else if (gameState.equals("mining"))
    endMining();


  else if (gameState.equals("final")) {
    initEstate();
    gameState = "auction";
  }
}
void beginMining() {
  gameState = "mining";
  startTime = millis();
  oilPrice = 0;
  list.shuffle();

  String[] inputLines = loadStrings("save.txt");

  String[][] lines = new String[inputLines.length][3];

  for (int i = 0; i < inputLines.length; i ++) {

    lines[i] = split(inputLines[i], ' ');
  }

  for (int i = 0; i < 5; i++) {

    Players[i].miningFunction = list.get(i);
    Players[i].loadStats(lines);
    Players[i].initializeStats();
    Players[i].loadImages();
  }

  if (year % 4 == 0) {
    leap = 1;
  } else leap = 0;

  playingSound = false;


  oilPrice = float(round(random(45, 55)*100)/100);

  if (random(0, 10) > 5)
    sign = -1;

  else sign = 1;
}

void endMining() {
  gameState = "final";
  for (int i = 0; i < 5; i++) {
    Players[i].money += Players[i].minedMoney;
    //Players[i].initializeStats();
    Players[i].loadImages();
  }
  savePlayers();
  year ++;
}



void seconds() {
  seconds = int(((millis()-startTime)/1000)+1);
}

void mouseReleased() {
  if (gameState.equals("upgrade"))
    for (int i = 0; i < Players.length; i++) {
      Players[i].changedStat = false;
      Players[i].loadImages();
      savePlayers();
      Players[i].initializeStats();
    }
}


void setButtons() {
}
void foo() {
  if ( myPort.available() > 0) {
    cVal = byte(myPort.read());
    if ((cVal != 10)&&(cVal != 13)) {

      for (int i = 4; i >= 0; i --) {
        int power = 1;
        for (int j = i; j > 0; j--) {
          power = power *2;
        }
        if (cVal >= power) {
          Players[i].buttonPressed = true;
          if (cVal != 1)
            cVal = byte(cVal - byte(power));
        } else Players[i].buttonPressed = false;
      }
    }
  }
}


float round2 (float num) {

  return (round(num*100)/100);
}
