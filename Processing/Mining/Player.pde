class Player {
  int xOffset;
  float money = 99999;
  String name;
  float minedMoney;

  float debt;

  color onColor = color(0);
  int onR, onG, onB;

  color offColor = color(0);
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

  float priceIncrement = 2;
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

  void loadStats (String[][] Lines) {

    for (int i = 0; i < Lines.length; i ++) {
      if (Lines[i][0].equals(name)) {

        if (Lines[i][1].equals("money")) {
          money = int(Lines[i][2]);
        }

        if (Lines[i][1].equals("searchBonus")) {
          searchBonus = int(Lines[i][2]);
        }

        if (Lines[i][1].equals("landQuality")) {
          landQuality = int(Lines[i][2]);
        }

        if (Lines[i][1].equals("onColor")) {
          onR = int(Lines[i][2]);
          onG = int(Lines[i][3]);
          onB = int(Lines[i][4]);
          onColor = color(onR, onG, onB);
        }
        if (Lines[i][1].equals("offColor")) {
          offR = int(Lines[i][2]);
          offG = int(Lines[i][3]);
          offB = int(Lines[i][4]);
          offColor = color(offR, offG, offB);
        }

        if (Lines[i][1].equals("horse")) {
          horse = boolean(Lines[i][2]);
          horse2 = boolean(Lines[i][3]);
          horsePrice = Lines[i][4];
        }
        if (Lines[i][1].equals("tank")) {
          tank = boolean(Lines[i][2]);
          tank2 = boolean(Lines[i][3]);
          tankPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("rig")) {
          rig = boolean(Lines[i][2]);
          rig2 = boolean(Lines[i][3]);
          rigPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("silo")) {
          silo = boolean(Lines[i][2]);
          silo2 = boolean(Lines[i][3]);
          siloPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("search")) {
          search = boolean(Lines[i][2]);
          search2 = boolean(Lines[i][3]);
          searchPrice = Lines[i][4];
        }
        if (Lines[i][1].equals("pipe")) {
          pipe = boolean(Lines[i][2]);
          pipe2 = boolean(Lines[i][3]);
          pipePrice = Lines[i][4];
        }
      }
    }
  }

  void initializeStats() {

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
    else if (silo)
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

  void printStats () {
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

  void ready() {
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

  void upgrade() {
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
    else if (mouseConstrained(xOffset, h - rectSize/2, w +100, h+rectSize/2)&& (money >= int(getPrice(horsePrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        money = money - int(getPrice(horsePrice));
        horsePrice = str(int(int(getPrice(horsePrice)) * priceIncrement)) + "$";
        horse = true;
        changedStat = true;
      }
    } else fill(255);

    ellipse(w, h, rectSize/2, rectSize/2);
    if (horse2) fill(0);
    else if ((mouseConstrained(xOffset, h - rectSize/2, w +100, h+rectSize/2))&&horse&& (money >= int(getPrice(horsePrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        horse2 = true;
        money = money - int(getPrice(horsePrice));
        horsePrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h, rectSize/2, rectSize/2);


    fill(0);
    text("Cisterna " + "(" + tankPrice + ")", w- rectSize / 2, h + rectSize);
    if (tank) fill(0);
    else if (mouseConstrained(xOffset+50, h + rectSize/2, w +100, h+ 3*rectSize/2)&& (money >= int(getPrice(tankPrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        tank = true;
        money = money - int(getPrice(tankPrice));
        tankPrice = str(int(int(getPrice(tankPrice)) * priceIncrement)) + "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize, rectSize/2, rectSize/2);
    if (tank2) fill(0);
    else if (mouseConstrained(xOffset+50, h + rectSize/2, w +100, h+ 3*rectSize/2)&&tank&& (money >= int(getPrice(tankPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        tank2 = true;
        money = money - int(getPrice(tankPrice));
        tankPrice = "MAX";
        changedStat = true;
      }
    } else fill (255);
    ellipse(w + rectSize, h + rectSize, rectSize/2, rectSize/2);


    fill(0);
    text("Věž " + "(" + rigPrice + ")", w- rectSize / 2, h + rectSize *2);
    if (rig) fill(0);
    else if (mouseConstrained(xOffset, h + 3*rectSize/2, w + 100, h+ 5*rectSize/2) && (money >= int(getPrice(rigPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        rig = true;
        money = money - int(getPrice(rigPrice));
        rigPrice = str(int(int(getPrice(rigPrice)) * priceIncrement)) + "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize *2, rectSize/2, rectSize/2);
    if (rig2) fill(0);
    else if (mouseConstrained(xOffset, h + 3* rectSize/2, w + 100, h+ 5*rectSize/2)&&rig && (money >= int(getPrice(rigPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        rig2 = true;
        money = money - int(getPrice(rigPrice));
        rigPrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize *2, rectSize/2, rectSize/2);
    fill(0);


    text("Silo " + "(" + siloPrice + ")", w- rectSize / 2, h + rectSize *3);
    if (silo) fill(0);
    else if (mouseConstrained(xOffset, h + 5* rectSize/2, w + 100, h+ 7*rectSize/2) && (money >= int(getPrice(siloPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        silo = true;
        money = money - int(getPrice(siloPrice));
        siloPrice = str(int(int(getPrice(siloPrice)) * priceIncrement)) + "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize *3, rectSize/2, rectSize/2);
    if (silo2) fill(0);
    else if (mouseConstrained(xOffset, h + 5* rectSize/2, w + 100, h+ 7*rectSize/2)&&silo && (money >= int(getPrice(siloPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        silo2 = true;
        money = money - int(getPrice(siloPrice));
        siloPrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize * 3, rectSize/2, rectSize/2);
    fill(0);


    text("Hledání " + "(" + searchPrice + ")", w- rectSize / 2, h + rectSize *4);
    if (search) fill(0);
    else if (mouseConstrained(xOffset, h + 7* rectSize/2, w + 100, h+ 9*rectSize/2) && (money >= int(getPrice(searchPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        search = true;
        money = money - int(getPrice(searchPrice));
        searchPrice = str(int(int(getPrice(searchPrice)) * priceIncrement))+"$";
        changedStat = true;
      }
    } else fill (255);
    ellipse(w, h + rectSize *4, rectSize/2, rectSize/2);
    if (search2) fill(0);
    else if (mouseConstrained(xOffset, h + 7* rectSize/2, w + 100, h+ 9*rectSize/2)&&search && (money >= int(getPrice(searchPrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        search2 = true;
        money = money - int(getPrice(searchPrice));
        searchPrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize *4, rectSize/2, rectSize/2);


    fill(0);
    text("Trubky " + "(" + pipePrice + ")", w- rectSize / 2, h + rectSize *5);
    if (pipe) fill(0);
    else if (mouseConstrained(xOffset, h + 9* rectSize/2, w +100, h+ 11*rectSize/2) && (money >= int(getPrice(pipePrice)))) {
      fill(150);
      if (mousePressed && !changedStat) {
        pipe = true;
        money = money - int(getPrice(pipePrice));
        pipePrice = str(int(int(getPrice(pipePrice)) * priceIncrement))+ "$";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w, h + rectSize *5, rectSize/2, rectSize/2);
    if (pipe2) fill(0);
    else if (mouseConstrained(xOffset, h + 9* rectSize/2, w + 100, h+ 11*rectSize/2)&&pipe && (money >= int(getPrice(pipePrice)))) {
      fill(150);
      if (mousePressed && !changedStat ) {
        pipe2 = !pipe2;
        money = money - int(getPrice(pipePrice));
        pipePrice = "MAX";
        changedStat = true;
      }
    } else fill(255);
    ellipse(w + rectSize, h + rectSize *5, rectSize/2, rectSize/2);
  }

  void loadImages() {

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


  void mining(int time) {

    if (lastMined != time) {
      miningBuffer = miningBuffer + mine(time);
      lastMined = time;
    }
  }

  float mine(int time) {
    float mining = 0;
    float variable = 0;
    switch (miningFunction) {

      // mineIncrease = zvýšení podle levelu věže
      // searchBonus = počet vyřešených úloh
      // landQuality = kvalita území

    case 0:
      variable = (1 + sin(sin(0.035 * time) - 0.07 * time));
      break;
    case 1:
      variable = (1 + sin(cos(2 + (0.07 * time)) - 0.035 * time));

      break;
    case 2:
      variable = (1 + cos(cos(0.07 * time) + 0.035 * time));

      break;
    case 3:
      variable = (1 + cos(sin(0.07 * time) + 0.035 * time));

      break;
    case 4:
      variable = (1 + cos(2 * sin(0.07 * time) - 0.035 * time));


      break;
    }
    variable = variable * (0.026 * (1 + mineIncrease) * searchBonus) ;
    float logh = log(landQuality - 4) / log(2);
float constant = 0.003 * (30 * (1 + mineIncrease) + 5 * logh * (3 + mineIncrease));
    mining = variable + constant;



    return mining;
  }

  void timers(int seconds) {

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

  void showMining() {

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


  void sell(float price) {
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





  void showUpgrades() {
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

  boolean mouseConstrained (int x1, int y1, int x2, int y2) {
    if (((mouseX > x1) && (mouseX < x2))&&((mouseY > y1)&&(mouseY < y2)))
      return true;

    else return false;
  }
}
