void showFinal () {
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
