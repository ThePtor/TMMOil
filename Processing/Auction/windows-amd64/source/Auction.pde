import processing.serial.*;
import processing.sound.*;
int seconds = 0;
Serial myPort;
byte cVal;
boolean changedState;
Player[] Players = new Player[5];
 color winnerColor = color(0);

String dataPath= "";  //Cesta do složky data

boolean useButtons = true;
boolean restart = false;

PFont font;
PImage miningBackground, upgradeBackground, up, down;
float oilPrice;
IntList list = new IntList();
int lastTime, lastTimeSold;
float lastPrice;
float soldBuffer;
float sellInfluence = 3;
boolean[] playerSold = new boolean[5];
float tempDelta;
int sign = 1;
float sellDelta;
int sellCounter;
float a1, a2, a3, b1, b2, b3, c1, c2, c3;

String winner;
float landPrice;

boolean won= false;

float X =0;

PImage background, winBanner, banner;

int year;

void setup() {
  dataPath = loadStrings("dataPath.txt")[0].trim();

background = loadImage(dataPath + "Auction/auction-bg.png");
winBanner = loadImage(dataPath + "Auction/auc-2.png");
banner = loadImage(dataPath + "Auction/auc-1.png");
  frameRate(30);

  for (int i = 0; i < 5; i++) {
    list.append(0);
  }
  list.shuffle();

     if(Serial.list().length > 0) {
     String portName = Serial.list()[0];

     myPort = new Serial(this, portName, 9600);
 }
 else{  
useButtons = false;
 }
  font = createFont(dataPath + "WesternBangBang-Regular.ttf", 80);
  textFont(font);
  fullScreen();
  size(1920, 1080);


  String[] inputLines = loadStrings(dataPath + "save.txt");

  String[][] lines = new String[inputLines.length][3];

  for (int i = 0; i < inputLines.length; i ++) {

    lines[i] = split(inputLines[i], ' ');
  }
 year = int(lines[0][1]);
  Players[0] = new Player("Červení", 0, list.get(0));
  Players[1] = new Player("Oranžoví", 375, list.get(1));
  Players[2] = new Player("Žlutí", 2*375, list.get(2));
  Players[3] = new Player("Zelení", 3*375, list.get(3));
  Players[4] = new Player("Modří", 4*375, list.get(4));

  for (int i = 0; i < Players.length; i++) {
    Players[i].loadStats(lines);
    Players[i].initializeStats();
    Players[i].loadImages();
  }
initEstate();
}



void draw() {
  
setButtons();
  estate();
  

}

void keyPressed () {
if (key == '\n')
finishEstate();
}

void keyReleased() {
  restart = false;
}




void setButtons() {
  
  if (!useButtons) {
  
  if (keyPressed && (key == 'r')) {
  Players[0].buttonPressed = true;
    }
  else {
  Players[0].buttonPressed = false;
  }
    if (keyPressed && (key == 'o')) {
  Players[1].buttonPressed = true;
    }
  else {
  Players[1].buttonPressed = false;
  }
  if (keyPressed && (key == 'y')) {
  Players[2].buttonPressed = true;
    }
  else {
  Players[2].buttonPressed = false;
  }
    if (keyPressed && (key == 'g')) {
  Players[3].buttonPressed = true;
    }
  else {
  Players[3].buttonPressed = false;
  }
  if (keyPressed && (key == 'b')) {
  Players[4].buttonPressed = true;
    }
  else {
  Players[4].buttonPressed = false;
  }


  
  }
  else{
  
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
    
    }}
  }
}


float round2 (float num) {

  return ((round(num*100)) * 0.01);
}
