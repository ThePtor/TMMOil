/* autogenerated by Processing revision 1286 on 2023-05-01 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import processing.serial.*;
import processing.sound.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Mining extends PApplet {



int seconds = 0;
Serial myPort;
byte cVal;
boolean changedState;
Player[] Players = new Player[5];

String dataPath= "";  //Cesta do složky data

boolean useButtons = true;
float priceLowerCap = 5;
PFont font;
PImage miningBackground, upgradeBackground, up, down;
float oilPrice;
IntList list = new IntList();
int lastTime, lastTimeSold;
float lastPrice;
float soldBuffer;
float sellInfluence = 0.4f; //Vliv prodeje na cenu
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
SoundFile sellSound;

int year = 2;


int leap = 1;
int timeLimit = 365;
String gameState = "upgrade";
int startTime;
 public void setup() {
  dataPath = loadStrings("dataPath.txt")[0].trim();

  frameRate(30);
  sellSound = new SoundFile(this,dataPath + "sounds/coin-001.wav");

  sound = new SoundFile(this,dataPath + "Turmoil OST - 07 - Oil Spill Hoedown.mp3");
  for (int i = 0; i < 5; i++) {
    list.append(i);
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
  /* size commented out by preprocessor */;
  //size(1920, 1080);


  String[] inputLines = loadStrings(dataPath + "save.txt");

  String[][] lines = new String[inputLines.length][3];

  for (int i = 0; i < inputLines.length; i ++) {

    lines[i] = split(inputLines[i], ' ');
  }
  year = PApplet.parseInt(lines[0][1]);
  if(year>9) year = 0;
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
  miningBackground = loadImage(dataPath + "background/background-rev2.png");
  upgradeBackground = loadImage(dataPath + "background/upgrades-3.png");
  up = loadImage(dataPath + "background/arrow-up.png");
  down = loadImage(dataPath + "background/arrow-down.png");
}



 public void draw() {
    setButtons();

  seconds();
  ///////////////////////////////////////////////////////////////////MINING
  if (gameState.equals("mining")) {
    //background(255);
    image(miningBackground, 0, 0);
    fill(0);
    textSize(80);
    textAlign(CENTER, CENTER);
    text(date(seconds), 210, 195);
    textSize(60);
    text(year + 1860, 210, 260);
    setButtons();

float sellPrice;
if (oilPrice < priceLowerCap){
sellPrice = priceLowerCap;
}
else {
sellPrice = oilPrice;
}
    for (int i = 0; i < Players.length; i++) {


      Players[i].mining(seconds);
      //Players[i].upgrade();
      Players[i].showUpgrades();
      Players[i].showMining();
      Players[i].timers(seconds);
      Players[i].sell(sellPrice);
    }

    oilPrice(year);
    soldBuffer();

    //savePlayers();

  }
    ///////////////////////////////////////////////////////////////////WIN

    if (gameState.equals("final"))
    showFinal();
  ///////////////////////////////////////////////////////////////////UPGRADE

  if (gameState.equals("upgrade")) {


    imageMode(CORNER);
    image(upgradeBackground, 0, 0);
    fill(0);

      for (int i = 0; i < Players.length; i++) {
      if(!Players[i].ready) {
      Players[i].upgrade();
      Players[i].showUpgrades();
      }
      else {
      Players[i].ready();
      Players[i].showUpgrades();
      
      }
    }
  
  
  if(
  Players[0].ready &&
  Players[1].ready &&
  Players[2].ready &&
  Players[3].ready &&
  Players[4].ready
  ){
  switchState();
  }}

}

 public void keyPressed () {
  if (!changedState);
  if (key == '\n')
    switchState();
}
 public void keyReleased() {
  changedState = false;
}

 public void switchState() {

  if (gameState.equals("upgrade"))
    beginMining();

  else if (gameState.equals("mining"))
    endMining();

    else if (gameState.equals("final"))
    exit();



}
 public void beginMining() {
  gameState = "mining";
  startTime = millis();
  oilPrice = 0;
  list.shuffle();

  String[] inputLines = loadStrings(dataPath + "save.txt");

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


  oilPrice = PApplet.parseFloat(round(random(45, 55)*100)/100);

  if (random(0, 10) > 5)
    sign = -1;

  else sign = 1;
}

 public void endMining() {
  gameState = "final";
  
  float sellPrice;
if (oilPrice < priceLowerCap){
sellPrice = priceLowerCap;
}
else {
sellPrice = oilPrice;
}
  for (int i = 0; i < 5; i++) {
    
    Players[i].minedMoney+=(Players[i].sellBuffer * sellPrice);
    Players[i].money += Players[i].minedMoney;
    Players[i].money += Players[i].debt;
    //Players[i].initializeStats();
    Players[i].loadImages();
  }
  year ++;
  savePlayers();
  
}



 public void seconds() {
  seconds = PApplet.parseInt(((millis()-startTime)/1000)+1);
}

 public void mouseReleased() {
  if (gameState.equals("upgrade"))
    for (int i = 0; i < Players.length; i++) {
      Players[i].changedStat = false;
      Players[i].loadImages();
      savePlayers();
      Players[i].initializeStats();
    }
}


 public void setButtons() {
  
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
    cVal = PApplet.parseByte(myPort.read());
    if ((cVal != 10)&&(cVal != 13)) {

      for (int i = 4; i >= 0; i --) {
        int power = 1;
        for (int j = i; j > 0; j--) {
          power = power *2;
        }
        if (cVal >= power) {
          Players[i].buttonPressed = true;
          if (cVal != 1)
            cVal = PApplet.parseByte(cVal - PApplet.parseByte(power));
        } else Players[i].buttonPressed = false;
      }
    
    }}
  }
}


 public float round2 (float num) {

  return (PApplet.parseFloat(round(num*100))/100);
}


 public String date (int day) {
String month;

if((!playingSound)&& (day > ((timeLimit + leap)-75))){
sound.play();
playingSound = true;
}

if (day >= timeLimit + leap) {
endMining();
}

if (day > 334) {
month = "Prosinec";
day -= 334;
}
else if (day > 304) {
month = "Listopad";
day -= 304;
}
else if (day > 273) {
month = "Říjen";
day -= 273;
}
else if (day > 243) {
month = "Září";
day -= 243;
}
else if (day > 212) {
month = "Srpen";
day -= 212;
}
else if (day > 181) {
month = "Červenec";
day -= 181;
}
else if (day > 151) {
month = "Červen";
day -= 151;
}
else if (day > 120) {
month = "Květen";
day -= 120;
}
else if (day > 90) {
month = "Duben";
day -= 90;
}
else if (day > 59 + leap) {
month = "Březen";
day -= (59 + leap);
}
else if (day > 31) {
month = "Únor";
day -= 31;
}
else {
month = "Leden";
}
return(day + "." + month);

}
 public void showFinal () {
PImage backImage = loadImage(dataPath + "background/background-end.png");
  float[] sums = new float[5];
  
  for (int i = 0; i < 5; i++) {
  sums[i] = Players[i].minedMoney;
  }

sums = sort(sums);

boolean[] set = new boolean[5];

String[] names = new String[5];
  for (int i = 0; i < 5; i++) {
  for (int j = 0; j < 5; j++) {
    
  if(Players[i].minedMoney == sums [j]) {
  if(!set[j]) {
  names[j] = Players[i].name;
  set[j] = true;
  break;
}
  }
  }
  imageMode(CORNER);
image(backImage, 0, 0);
  }
  
 textAlign(CENTER,CENTER);
 
 fill(0);
 textSize (120);
 text(names[4], 960, 210);
 text(sums[4] + "$", 960, 330);
 
 textSize (120);
 text(names[3], 640, 530);
 text(sums[3] + "$", 640, 650);
 
 textSize (120);
 text(names[2], 1280, 530);
 text(sums[2] + "$", 1280, 650);
 
  fill(255);
 textSize (80);
 text(names[1] + "   " + sums[1] + "$", 640, 865);
 

 textSize (80);
 text(names[0] + "   " +sums[0] + "$", 1280, 865);

}
class Player {
  int xOffset;
  float money = 99999;
  String name;
  float minedMoney;

  float debt;

  int onColor = color(0);
  int onR, onG, onB;

  int offColor = color(0);
  int offR, offG, offB;

  int searchBonus;
  int landQuality;

  boolean sold = false;
  int soldHold;
  float soldAmount;
  float soldOil;

  float mined;
  boolean horse, horse2;
  String horsePrice = "200$";
  boolean tank, tank2;
  String tankPrice = "200$";
  boolean rig, rig2;
  String rigPrice = "200$";
  boolean silo, silo2;
  String siloPrice = "200$";
  boolean search, search2;
  String searchPrice = "200$";
  boolean pipe, pipe2;
  String pipePrice = "200$";

  float priceIncrement = 1.5f;
  boolean changedStat = false;

  PImage horseImage, rigImage, tankImage, siloImage, pipeImage, stopWatch, stopWatchBack;

  boolean ready;

  int miningFunction;
  float miningBuffer;
  int bufferTimer;
  float lastMined;

  float siloCap;
  int bufferInterval = 3;
  int mineIncrease = 10;

  int timerLast;
  int timer;

  boolean buttonPressed = false;
  float sellBuffer;
  int sellCap = 20;
  int sellCooldown;
  int maxCooldown = 0;
  int cooldownHalfTime = 3;


  Player (String tempName, int tempOffset, int tempMiningFunction) {
    name = tempName;
    xOffset = tempOffset;
    miningFunction = tempMiningFunction;
  }

   public void loadStats (String[][] Lines) {

    for (int i = 0; i < Lines.length; i ++) {
      if (Lines[i][0].equals(name)) {

        if (Lines[i][1].equals("money")) {
          money = PApplet.parseInt(Lines[i][2]);
        }

        if (Lines[i][1].equals("searchBonus")) {
          searchBonus = PApplet.parseInt(Lines[i][2]);
        }

        if (Lines[i][1].equals("landQuality")) {
          landQuality = PApplet.parseInt(Lines[i][2]);
        }

        if (Lines[i][1].equals("onColor")) {
          onR = PApplet.parseInt(Lines[i][2]);
          onG = PApplet.parseInt(Lines[i][3]);
          onB = PApplet.parseInt(Lines[i][4]);
          onColor = color(onR, onG, onB);
        }
        if (Lines[i][1].equals("offColor")) {
          offR = PApplet.parseInt(Lines[i][2]);
          offG = PApplet.parseInt(Lines[i][3]);
          offB = PApplet.parseInt(Lines[i][4]);
          offColor = color(offR, offG, offB);
        }

        if (Lines[i][1].equals("horse")) {
          horse = PApplet.parseBoolean(Lines[i][2]);
          horse2 = PApplet.parseBoolean(Lines[i][3]);
          horsePrice = Lines[i][4];
        }
        if (Lines[i][1].equals("tank")) {
          tank = PApplet.parseBoolean(Lines[i][2]);
          tank2 = PApplet.parseBoolean(Lines[i][3]);
          tankPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("rig")) {
          rig = PApplet.parseBoolean(Lines[i][2]);
          rig2 = PApplet.parseBoolean(Lines[i][3]);
          rigPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("silo")) {
          silo = PApplet.parseBoolean(Lines[i][2]);
          silo2 = PApplet.parseBoolean(Lines[i][3]);
          siloPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("search")) {
          search = PApplet.parseBoolean(Lines[i][2]);
          search2 = PApplet.parseBoolean(Lines[i][3]);
          searchPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("pipe")) {
          pipe = PApplet.parseBoolean(Lines[i][2]);
          pipe2 = PApplet.parseBoolean(Lines[i][3]);
          pipePrice = Lines[i][4];
        }
      }
    }
  }

   public void initializeStats() {

    if (pipe2)
      bufferInterval = 1;
    else if (pipe)
      bufferInterval = 3;
    else bufferInterval = 5;

    if (rig2)
      mineIncrease =3;
    else if (rig)
      mineIncrease = 2;
    else
      mineIncrease = 1;

    if (silo2)
      siloCap = 200;
    else if (silo)
      siloCap = 100;
    else
      siloCap = 60;


    if (tank2)
      sellCap = 30;
    else if (tank)
      sellCap = 20;
    else
      sellCap = 15;

    if (horse2) {
      maxCooldown = 5;
      cooldownHalfTime = 2;
    } else if (horse) {
      maxCooldown = 7;
      cooldownHalfTime = 3;
    } else {
      maxCooldown = 10;
      cooldownHalfTime = 4;
    }

    if (money < 0) {
      debt = money;
    }

    sold = false;
    soldHold = 0;
    soldAmount = 0;

    mined = 0;
    minedMoney = 0;

    miningBuffer = 0;
    bufferTimer = 0;
    lastMined = 0;

    timerLast = 0;
    timer = 0;

    sellBuffer = 0;
    sellCooldown = 0;
  }

   public void printStats () {
    println(name + " " + "money "+ money);
    println(name + " " + "horse"+ " " + horse + " " + horse2);
    println(name + " " + "tank"+ " " + tank + " " + tank2);
    println(name + " " + "rig"+ " " + rig + " " + rig2);
    println(name + " " + "silo"+ " " + silo + " " + silo2);
    println(name + " " + "search"+ " " + search + " " + search2);
    println(name + " " + "pipe"+ " " + pipe + " " + pipe2);
  }

  //void saveStats() {

  //  PrintWriter output = createWriter("save.txt");
  //  output.println(name + " " + "money"+ " " + money);
  //  output.println(name + " " + "horse"+ " " + horse + " " + horse2 + " " + horsePrice);
  //  output.println(name + " " + "tank"+ " " + tank + " " + tank2 + " " + tankPrice);
  //  output.println(name + " " + "rig"+ " " + rig + " " + rig2 + " " + rigPrice);
  //  output.println(name + " " + "silo"+ " " + silo + " " + silo2 + " " + siloPrice);
  //  output.println(name + " " + "search"+ " " + search + " " + search2 + " " + searchPrice);
  //  output.println(name + " " + "pipe"+ " " + pipe + " " + pipe2 + " " + pipePrice);
  //  output.println(name + " " + "onColor"+ " " + onColor);
  //  output.println(name + " " + "onColor"+ " " + onColor);
  //  output.println(name + " " + "searchBonus"+ " " + searchBonus);
  //  output.flush();
  //  output.close();
  //}

   public void ready() {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(100);
    text(name, xOffset + 210, 100);

    fill(0);
    ellipseMode(CORNER);
    textSize(100);


    text("MŮŽEME", xOffset + 210, (height/2) -250);
    text("ZAČÍT", xOffset + 210, (height/2) - 150);
    textAlign(RIGHT, TOP);
    textSize(40);
  }

   public void upgrade() {
    if (buttonPressed) ready = true;
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(100);
    text(name, xOffset + 210, 100);



    fill(0);
    ellipseMode(CORNER);
    int rectSize = 50;
    int h = 300;
    int w = xOffset + 270;
    textSize(80);
    text(money + "$", xOffset + 210, h - 100);
    textAlign(RIGHT, TOP);
    textSize(40);
    text("Kůň " + "(" + horsePrice + ")", w - rectSize / 2, h);
    if (horse) fill(0);
    else if (mouseConstrained(xOffset, h - rectSize/2, w +100, h+rectSize/2)&& (money >= PApplet.parseInt(getPrice(horsePrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        money = money - PApplet.parseInt(getPrice(horsePrice));
        horsePrice = str(PApplet.parseInt(PApplet.parseInt(getPrice(horsePrice)) * priceIncrement)) + "$";
        horse = true;
        changedStat = true;
      }
    } else fill(255);

    ellipse(w, h, rectSize/2, rectSize/2);
    if (horse2) fill(0);
    else if ((mouseConstrained(xOffset, h - rectSize/2, w +100, h+rectSize/2))&&horse&& (money >= PApplet.parseInt(getPrice(horsePrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        horse2 = true;
        money = money - PApplet.parseInt(getPrice(horsePrice));
        horsePrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h, rectSize/2, rectSize/2);


    fill(0);
    text("Cisterna " + "(" + tankPrice + ")", w- rectSize / 2, h + rectSize);
    if (tank) fill(0);
    else if (mouseConstrained(xOffset+50, h + rectSize/2, w +100, h+ 3*rectSize/2)&& (money >= PApplet.parseInt(getPrice(tankPrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        tank = true;
        money = money - PApplet.parseInt(getPrice(tankPrice));
        tankPrice = str(PApplet.parseInt(PApplet.parseInt(getPrice(tankPrice)) * priceIncrement)) + "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize, rectSize/2, rectSize/2);
    if (tank2) fill(0);
    else if (mouseConstrained(xOffset+50, h + rectSize/2, w +100, h+ 3*rectSize/2)&&tank&& (money >= PApplet.parseInt(getPrice(tankPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        tank2 = true;
        money = money - PApplet.parseInt(getPrice(tankPrice));
        tankPrice = "MAX";
        changedStat = true;
      }
    } else fill (255);
    ellipse(w + rectSize, h + rectSize, rectSize/2, rectSize/2);


    fill(0);
    text("Věž " + "(" + rigPrice + ")", w- rectSize / 2, h + rectSize *2);
    if (rig) fill(0);
    else if (mouseConstrained(xOffset, h + 3*rectSize/2, w + 100, h+ 5*rectSize/2) && (money >= PApplet.parseInt(getPrice(rigPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        rig = true;
        money = money - PApplet.parseInt(getPrice(rigPrice));
        rigPrice = str(PApplet.parseInt(PApplet.parseInt(getPrice(rigPrice)) * priceIncrement)) + "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize *2, rectSize/2, rectSize/2);
    if (rig2) fill(0);
    else if (mouseConstrained(xOffset, h + 3* rectSize/2, w + 100, h+ 5*rectSize/2)&&rig && (money >= PApplet.parseInt(getPrice(rigPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        rig2 = true;
        money = money - PApplet.parseInt(getPrice(rigPrice));
        rigPrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize *2, rectSize/2, rectSize/2);
    fill(0);


    text("Silo " + "(" + siloPrice + ")", w- rectSize / 2, h + rectSize *3);
    if (silo) fill(0);
    else if (mouseConstrained(xOffset, h + 5* rectSize/2, w + 100, h+ 7*rectSize/2) && (money >= PApplet.parseInt(getPrice(siloPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        silo = true;
        money = money - PApplet.parseInt(getPrice(siloPrice));
        siloPrice = str(PApplet.parseInt(PApplet.parseInt(getPrice(siloPrice)) * priceIncrement)) + "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize *3, rectSize/2, rectSize/2);
    if (silo2) fill(0);
    else if (mouseConstrained(xOffset, h + 5* rectSize/2, w + 100, h+ 7*rectSize/2)&&silo && (money >= PApplet.parseInt(getPrice(siloPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        silo2 = true;
        money = money - PApplet.parseInt(getPrice(siloPrice));
        siloPrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize * 3, rectSize/2, rectSize/2);
    fill(0);


    text("Hledání " + "(" + searchPrice + ")", w- rectSize / 2, h + rectSize *4);
    if (search) fill(0);
    else if (mouseConstrained(xOffset, h + 7* rectSize/2, w + 100, h+ 9*rectSize/2) && (money >= PApplet.parseInt(getPrice(searchPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        search = true;
        money = money - PApplet.parseInt(getPrice(searchPrice));
        searchPrice = str(PApplet.parseInt(PApplet.parseInt(getPrice(searchPrice)) * priceIncrement))+"$";
        changedStat = true;
      }
    } else fill (255);
    ellipse(w, h + rectSize *4, rectSize/2, rectSize/2);
    if (search2) fill(0);
    else if (mouseConstrained(xOffset, h + 7* rectSize/2, w + 100, h+ 9*rectSize/2)&&search && (money >= PApplet.parseInt(getPrice(searchPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        search2 = true;
        money = money - PApplet.parseInt(getPrice(searchPrice));
        searchPrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize *4, rectSize/2, rectSize/2);


    fill(0);
    text("Trubky " + "(" + pipePrice + ")", w- rectSize / 2, h + rectSize *5);
    if (pipe) fill(0);
    else if (mouseConstrained(xOffset, h + 9* rectSize/2, w +100, h+ 11*rectSize/2) && (money >= PApplet.parseInt(getPrice(pipePrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        pipe = true;
        money = money - PApplet.parseInt(getPrice(pipePrice));
        pipePrice = str(PApplet.parseInt(PApplet.parseInt(getPrice(pipePrice)) * priceIncrement))+ "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize *5, rectSize/2, rectSize/2);
    if (pipe2) fill(0);
    else if (mouseConstrained(xOffset, h + 9* rectSize/2, w + 100, h+ 11*rectSize/2)&&pipe && (money >= PApplet.parseInt(getPrice(pipePrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        pipe2 = !pipe2;
        money = money - PApplet.parseInt(getPrice(pipePrice));
        pipePrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize *5, rectSize/2, rectSize/2);
  }

   public void loadImages() {

    stopWatch = loadImage(dataPath + "256px/256px-town.png");
    stopWatchBack = loadImage(dataPath + "256px/256px-rigs.png");

    if (horse2) {
      horseImage = loadImage(dataPath + "256px/256px-horse-2.png");
    } else if (horse) {
      horseImage = loadImage(dataPath + "256px/256px-horse-1.png");
    } else {
      horseImage = loadImage(dataPath + "256px/256px-horse-0.png");
    }

    if (silo2) {
      siloImage = loadImage(dataPath + "320px/320px-silo-2.png");
    } else if (silo) {
      siloImage = loadImage(dataPath + "320px/320px-silo-1.png");
    } else {
      siloImage = loadImage(dataPath + "320px/320px-silo-0.png");
    }


    if (rig2) {
      rigImage = loadImage(dataPath + "320px/320px-rig-2.png");
    } else if (rig) {
      rigImage = loadImage(dataPath + "320px/320px-rig-1.png");
    } else {
      rigImage = loadImage(dataPath + "320px/320px-rig-0.png");
    }


    if (tank2) {
      tankImage = loadImage(dataPath + "256px/256px-wagon-2.png");
    } else if (tank) {
      tankImage = loadImage(dataPath + "256px/256px-wagon-1.png");
    } else {
      tankImage = loadImage(dataPath + "256px/256px-wagon-0.png");
    }

    if (pipe2) {
      pipeImage = loadImage(dataPath + "320px/320px-connection-2.png");
    } else if (pipe) {
      pipeImage = loadImage(dataPath + "320px/320px-connection-1.png");
    } else {
      pipeImage = loadImage(dataPath + "320px/320px-connection-1.png");
    }
  }


   public void mining(int time) {

    if (lastMined != time) {
      miningBuffer = miningBuffer + mine(time);
      lastMined = time;
    }
  }

   public float mine(int time) {
    float mining = 0;
    float variable = 0;
    switch (miningFunction) {

      // mineIncrease = zvýšení podle levelu věže
      // searchBonus = počet vyřešených úloh
      // landQuality = kvalita území

    case 0:
      variable = (1 + sin(sin(0.035f * time) - 0.07f * time));
      break;
    case 1:
      variable = (1 + sin(cos(2 + (0.07f * time)) - 0.035f * time));

      break;
    case 2:
      variable = (1 + cos(cos(0.07f * time) + 0.035f * time));

      break;
    case 3:
      variable = (1 + cos(sin(0.07f * time) + 0.035f * time));

      break;
    case 4:
      variable = (1 + cos(2 * sin(0.07f * time) - 0.035f * time));


      break;
    }
    variable = variable * (0.026f * (1 + mineIncrease) * searchBonus) ;
    float logh = log(landQuality - 4) / log(2);
float constant = 0.003f * (30 * (1 + mineIncrease) + 5 * logh * (3 + mineIncrease));
    mining = variable + constant;



    return mining;
  }

   public void timers(int seconds) {

    timer = (seconds - timerLast);


    bufferTimer = bufferTimer + timer;
    if (bufferTimer >= bufferInterval) {
      bufferTimer = 0;
      mined = mined + miningBuffer;
      if (mined > siloCap)
        mined = siloCap;
      miningBuffer = 0;
    }
    if (sellCooldown > 0)
      sellCooldown = sellCooldown - timer;
    if (soldHold > 0)
      soldHold -= timer;
    if (soldHold == 0)
      sold = false;
    timerLast = seconds;
  }

   public void showMining() {

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(100);


    fill(0);
    int rectSize = 50;
    int h = 300;
    int w = xOffset +210;
    textSize(80);
    text(name, xOffset + 210, h+120);
    text(round(minedMoney) + "$", w, h+200);
    textSize(40);
    textAlign(CENTER, CENTER);

    fill(100);

    if (sold)
      text("+" + round2(soldAmount) + "$", w, h+250);
    textAlign(RIGHT, TOP);
    fill(0);
    int miningOffset = 0;
    if (silo2)
      miningOffset = 80;
    else if (silo)
      miningOffset = 40;
    else miningOffset = 0;

    //text("buffer: " + miningBuffer,w, h + 100);
    text(round2(mined) + "/" + siloCap, w + 130, h + 370 + rectSize - miningOffset);
    //text("sellBuffer: " + sellBuffer, w , h + 2*rectSize);
    //text("sellCooldown: " + sellCooldown, w, h  + 3*rectSize);
  }


   public void sell(float price) {
    price = abs(price);
    if (sellCooldown == cooldownHalfTime) {
      if (sellBuffer>0) {
        sold = true;
        soldHold = 2;
        sellSound.play();
      }
      if (sellBuffer != 0)
        soldAmount = sellBuffer * abs(price);
      soldOil = sellBuffer;
      minedMoney = minedMoney + (sellBuffer * price);
      sellBuffer = 0;
    }

    if (buttonPressed && (sellCooldown == 0)) {
      if (mined >= sellCap) {
        sellBuffer = sellCap;
        mined = mined - sellCap;
        sellCooldown = maxCooldown;
      } else if (mined > 0) {
        sellBuffer = mined;
        mined = 0;
        sellCooldown = maxCooldown;
      }
    }
  }





   public void showUpgrades() {
    imageMode(CORNER);
    if (sellCooldown == 0) {
      image(horseImage, xOffset + 82, 882);
      image(tankImage, xOffset+ 82, 882);
    } else {
      imageMode(CENTER);
      if (sellCooldown > (cooldownHalfTime)) {
        textAlign(CENTER, CENTER);
        textSize(80);
        text(sellCooldown - cooldownHalfTime, xOffset + 210 + 64, 970 );
        image(stopWatch, xOffset + 210, 970);
      } else {
        textAlign(CENTER, CENTER);
        textSize(80);
        text(sellCooldown, xOffset + 210 - 64, 970 );
        image(stopWatchBack, xOffset + 210, 970);
      }
    }
    imageMode(CORNER);
    image(rigImage, xOffset + 50, 592);

    if (pipe||pipe2)
      image(pipeImage, xOffset + 50, 592);
    image(siloImage, xOffset+ 50, 592);
  }

  public String getPrice(String str) {
    str = str.substring(0, str.length() - 1);
    return str;
  }

   public boolean mouseConstrained (int x1, int y1, int x2, int y2) {
    if (((mouseX > x1) && (mouseX < x2))&&((mouseY > y1)&&(mouseY < y2)))
      return true;

    else return false;
  }
}
 public void oilPrice(int priceFunction) {
  float priceDelta = 0;
  int time = seconds;
  if (time != lastTime) {
    switch (priceFunction) {

    case 0:

      a1 = 1.71f;
      a2 = 0.72f;
      a3 = 0.56f;
      b1 = 1.03f;
      b2 = 2.78f;
      b3 = 1.34f;
      c1 = -0.19f;
      c2 = 0.24f;
      c3 = 2.8f;
      break;
    case 1:

      a1 = 1.59f;
      a2 = 0.39f;
      a3 = 0.66f;
      b1 = 0.58f;
      b2 = 2.74f;
      b3 = 1.21f;
      c1 = 0.02f;
      c2 = 0.48f;
      c3 = 1.79f;
      break;
    case 2:
      a1 = 1.49f;
      a2 = 0.87f;
      a3 = 0.8f;
      b1 = 0.33f;
      b2 = 2.5f;
      b3 = 1.24f;
      c1 = 0.49f;
      c2 = 0.92f;
      c3 = 2.17f;
      break;
    case 3:
      a1 = 2.5f;
      a2 = 0.82f;
      a3 = 0.75f;
      b1 = -1;
      b2 = 2.65f;
      b3 = 1.87f;
      c1 = -0.37f;
      c2 = 0.58f;
      c3 = 1.62f;   
      break;
    case 4:
      a1 = 1.95f;
      a2 = 0.0f;
      a3 = 0.66f;
      b1 = -1.38f;
      b2 = 2.76f;
      b3 = 1.78f;
      c1 = 0.21f;
      c2 = 0.32f;
      c3 = 1.43f;
      break;
    case 5:
      a1 = 1.61f;
      a2 = 1.43f;
      a3 = 0.68f;
      b1 = -1.69f;
      b2 = 2.45f;
      b3 = 1.63f;
      c1 = -0.47f;
      c2 = 0.75f;
      c3 = 2.66f;
      break;
    case 6:
      a1 = 1.27f;
      a2 = 0.05f;
      a3 = 0.7f;
      b1 = 0.02f;
      b2 = 2.58f;
      b3 = 1.5f;
      c1 = -0.13f;
      c2 = 0.54f;
      c3 = 1.48f;
      break;
    case 7:
      a1 = 1.84f;
      a2 = 0.81f;
      a3 = 0.61f;
      b1 = -1.5f;
      b2 = 2.64f;
      b3 = 1.09f;
      c1 = -0.42f;
      c2 = 0.61f;
      c3 = 2.73f;
      break;
    case 8:
      a1 = 2.17f;
      a2 = 0.93f;
      a3 = 0.71f;
      b1 = 0.4f;
      b2 = 2.8f;
      b3 = 1.5f;
      c1 = 0.2f;
      c2 = 0.04f;
      c3 = 2.44f;
      break;
    case 9:
      a1 = 2.37f;
      a2 = 0.03f;
      a3 = 0.53f;
      b1 = 0.26f;
      b2 = 2.67f;
      b3 = 1.43f;
      c1 = 0.27f;
      c2 = 0.8f;
      c3 = 2.44f;
      break;
    }

    lastTime = time;
    priceDelta =(sellInfluence * sellDelta) + sign * 8* 0.175f * priceDer(a1, a2, a3, b1, b2, b3, c1, c2, c3, time);
   // priceDelta =sellInfluence * sellDelta;
    lastPrice = priceDelta;
    oilPrice += priceDelta;
  }

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(250);
  float sellPrice;
  boolean isCapped = false;
if (oilPrice < priceLowerCap){
sellPrice = priceLowerCap;
isCapped = true;
}
else {
sellPrice = oilPrice;
}
  text(abs(round2(sellPrice)) + "$", width/2, 184);
  textSize(100);
  textAlign(RIGHT, CENTER);
  imageMode(CENTER);
  if (lastPrice > 0) {
    fill(0xFF2EB135);
    if (!isCapped)
    text("+" + round2(lastPrice) + "$", width-70, 220);
    else
    text(0 + "$", width-70, 220);
    image(up, width-310, 220, 100, 100);
  } else {
    fill(0xFFFF0000);
    if (!isCapped)
    text((round2(lastPrice + tempDelta)) + "$", width-70, 220);
    else
    text(0 + "$", width-70, 220);
    image(down, width-310, 220, 100, 100);
  }
  imageMode(CORNER);
}

 public float priceDer (float a1, float  a2, float  a3, float  b1, float  b2, float  b3, float  c1, float  c2, float  c3, int x) {

  float X = x * 0.175f;

  return((a1*a3*cos(a2+a3*X)) + (b1*b3*cos(b2+b3*X)) + (c1*c3*cos(c2+c3*X)));
}

 public void soldBuffer() {

  int time = seconds;

  if (time != lastTimeSold) {
    tempDelta = 0;
    if (soldBuffer > 0) {

      sellCounter ++;


      sellDelta = pow(1.2f, sellCounter/2);

      if (soldBuffer - sellDelta < 0) {
        sellDelta = soldBuffer;
      }

      soldBuffer -= sellDelta;
    } else {
      sellCounter = 0;
      sellDelta = 0;
    }

    for (int i = 0; i < 5; i++) {

      if (Players[i].sellCooldown == Players[i].cooldownHalfTime)
        soldBuffer += Players[i].soldOil;
      oilPrice += - sellInfluence * Players[i].soldOil;
      tempDelta += - sellInfluence * Players[i].soldOil;
    }

    lastTimeSold = time;
  }
}
 public void savePlayers() {
  PrintWriter output = createWriter(dataPath + "save.txt");
  output.println("year"  + " " + year);
  for (int i = 0; i < Players.length; i ++) {


    output.println(Players[i].name + " " + "money"+ " " +Players[i].money);
    output.println(Players[i].name + " " + "horse"+ " " + Players[i].horse + " " + Players[i].horse2+ " " + Players[i].horsePrice);
    output.println(Players[i].name + " " + "tank"+ " " + Players[i].tank + " " + Players[i].tank2+ " " + Players[i].tankPrice);
    output.println(Players[i].name + " " + "rig"+ " " + Players[i].rig + " " + Players[i].rig2+ " " + Players[i].rigPrice);
    output.println(Players[i].name + " " + "silo"+ " " + Players[i].silo + " " + Players[i].silo2+ " " + Players[i].siloPrice);
    output.println(Players[i].name + " " + "search"+ " " + Players[i].search + " " + Players[i].search2+ " " + Players[i].searchPrice);
    output.println(Players[i].name + " " + "pipe"+ " " + Players[i].pipe + " " + Players[i].pipe2+ " " + Players[i].pipePrice);
    output.println(Players[i].name + " " + "searchBonus"+ " " + Players[i].searchBonus);
    output.println(Players[i].name + " " + "landQuality"+ " " + Players[i].landQuality);
    output.println(Players[i].name + " " + "onColor"+ " " + Players[i].onR + " " + Players[i].onG + " " + Players[i].onB);
    output.println(Players[i].name + " " + "offColor"+ " " + Players[i].offR + " " + Players[i].offG + " " + Players[i].offB);
  }
  
  output.flush();
  output.close();
}


  public void settings() { fullScreen(); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Mining" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
