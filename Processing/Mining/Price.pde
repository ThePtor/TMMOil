void oilPrice(int priceFunction) {
  float priceDelta = 0;
  int time = seconds;
  if (time != lastTime) {
    switch (priceFunction) {

    case 0:

      a1 = 1.71;
      a2 = 0.72;
      a3 = 0.56;
      b1 = 1.03;
      b2 = 2.78;
      b3 = 1.34;
      c1 = -0.19;
      c2 = 0.24;
      c3 = 2.8;
      break;
    case 1:

      a1 = 1.59;
      a2 = 0.39;
      a3 = 0.66;
      b1 = 0.58;
      b2 = 2.74;
      b3 = 1.21;
      c1 = 0.02;
      c2 = 0.48;
      c3 = 1.79;
      break;
    case 2:
      a1 = 1.49;
      a2 = 0.87;
      a3 = 0.8;
      b1 = 0.33;
      b2 = 2.5;
      b3 = 1.24;
      c1 = 0.49;
      c2 = 0.92;
      c3 = 2.17;
      break;
    case 3:
      a1 = 2.5;
      a2 = 0.82;
      a3 = 0.75;
      b1 = -1;
      b2 = 2.65;
      b3 = 1.87;
      c1 = -0.37;
      c2 = 0.58;
      c3 = 1.62;   
      break;
    case 4:
      a1 = 1.95;
      a2 = 0.0;
      a3 = 0.66;
      b1 = -1.38;
      b2 = 2.76;
      b3 = 1.78;
      c1 = 0.21;
      c2 = 0.32;
      c3 = 1.43;
      break;
    case 5:
      a1 = 1.61;
      a2 = 1.43;
      a3 = 0.68;
      b1 = -1.69;
      b2 = 2.45;
      b3 = 1.63;
      c1 = -0.47;
      c2 = 0.75;
      c3 = 2.66;
      break;
    case 6:
      a1 = 1.27;
      a2 = 0.05;
      a3 = 0.7;
      b1 = 0.02;
      b2 = 2.58;
      b3 = 1.5;
      c1 = -0.13;
      c2 = 0.54;
      c3 = 1.48;
      break;
    case 7:
      a1 = 1.84;
      a2 = 0.81;
      a3 = 0.61;
      b1 = -1.5;
      b2 = 2.64;
      b3 = 1.09;
      c1 = -0.42;
      c2 = 0.61;
      c3 = 2.73;
      break;
    case 8:
      a1 = 2.17;
      a2 = 0.93;
      a3 = 0.71;
      b1 = 0.4;
      b2 = 2.8;
      b3 = 1.5;
      c1 = 0.2;
      c2 = 0.04;
      c3 = 2.44;
      break;
    case 9:
      a1 = 2.37;
      a2 = 0.03;
      a3 = 0.53;
      b1 = 0.26;
      b2 = 2.67;
      b3 = 1.43;
      c1 = 0.27;
      c2 = 0.8;
      c3 = 2.44;
      break;
    }

    lastTime = time;
    priceDelta =round2((sellInfluence * sellDelta) + sign * 8* 0.175 * priceDer(a1, a2, a3, b1, b2, b3, c1, c2, c3, time));
    lastPrice = priceDelta;
    oilPrice += priceDelta;
  }

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(250);
  text(abs(oilPrice) + "$", width/2, 184);
  textSize(100);
  textAlign(RIGHT, CENTER);
  imageMode(CENTER);
  if (lastPrice > 0) {
    fill(#2EB135);
    text("+" + lastPrice + "$", width-70, 220);
    image(up, width-310, 220, 100, 100);
  } else {
    fill(#ff0000);
    text((lastPrice + tempDelta) + "$", width-70, 220);
    image(down, width-310, 220, 100, 100);
  }
  imageMode(CORNER);
}

float priceDer (float a1, float  a2, float  a3, float  b1, float  b2, float  b3, float  c1, float  c2, float  c3, int x) {

  X = x * 0.175;

  return((a1*a3*cos(a2+a3*X)) + (b1*b3*cos(b2+b3*X)) + (c1*c3*cos(c2+c3*X)));
}

void soldBuffer() {

  int time = seconds;

  if (time != lastTimeSold) {
    tempDelta = 0;
    if (soldBuffer > 0) {

      sellCounter ++;


      sellDelta = pow(2, sellCounter);

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
