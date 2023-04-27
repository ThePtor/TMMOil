void estate() {
  //background(255);
  imageMode(CORNER);
  image(background, 0, 0);
  textSize(200);
  fill(0);
  
  
if (!won){
    

for(int i = 0; i < 5; i++) {
  setButtons();
  if((Players[i].buttonPressed) && (Players[i].money >= landPrice)){
  winner = Players[i].name;
  winnerColor = Players[i].onColor;
  won = true;
  break;
  }
}
imageMode(CENTER);
image(banner, width/2,height/2);
textSize(250);
if(landPrice > 1000) 
    text(int(landPrice) + " $", width/2, height/2 - 60);
else if (landPrice > 100)
    text(nf(landPrice, 0, 1) + " $", width/2, height/2 - 60);
    
else 
    text(nf(landPrice, 0, 2) + " $", width/2, height/2 - 60);
   //text(int(Players[0].buttonPressed), width/2, height/2);
if(landPrice>0)
  landPrice -= landPrice * 0.001;

for(int i = 0; i < 5; i ++) {

drawPlayer(i);

}



}

else {
  imageMode(CENTER);
  image(winBanner, width/2, height/2);
  fill(winnerColor);
  textSize(200);
  text(winner, width/2, height/2-300);
  fill(0);
  textSize(100);
  text("Získávají akcii za ", width/2, height/2 - 150);
  textSize(200);
  text(int(landPrice) + " $", width/2, height/2);
  if(!restart)
  if (keyPressed && (key == 'a')) {
    restart();
  initEstate();
  restart = true;
  }
}

}



void initEstate() {
  landPrice = 0;
for(int i = 0; i < 5; i++) {
  Players[i].initializeStats();
if (Players[i].money > landPrice)
landPrice = Players[i].money;
won = false;

}

landPrice = landPrice * 1.1;
winner = "";


}

void finishEstate(){
for(int i = 0; i < 5; i++) {
if (Players[i].name.equals(winner))
Players[i].money -= landPrice;
savePlayers();
exit();
}
}

void restart () {
for(int i = 0; i < 5; i++) {
if (Players[i].name.equals(winner))
Players[i].money -= landPrice;
savePlayers();

}
}


void drawPlayer(int index) {
  
  strokeWeight(10);
  rectMode(CENTER);
  stroke(Players[index].onColor);
  
  
  if(Players[index].money >= landPrice)
  fill(Players[index].onColor);
  else
  fill(Players[index].offColor);
  
  rect(index*(width/5) + width/10, 200, 300, 220);
  textSize(100);
  textAlign(CENTER, CENTER);
  
  fill(0);
  text( Players[index].name,index*(width/5) + width/10, 150);
  
  fill(0);
  textSize(80);
  text( round2(Players[index].money) + " $",index*(width/5) + width/10, 250);
 

  

}
