void oilPrice(int priceFunction) {
  float priceDelta = 0;
  int time = seconds;

  if (time != lastTime) {
    switch (priceFunction) {

    case 0:
      priceDelta = int (random(-2, 3));
      if ((oilPrice + priceDelta) < 0)
        priceDelta = abs(priceDelta);
      lastPrice = priceDelta;
      break;
    case 1:

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
    case 2:

      break;
    case 3:

      break;
    case 4:

      break;
    case 5:

      break;
    case 6:

      break;
    case 7:

      break;
    case 8:

      break;
    case 9:

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
