void estate() {
  background(255);
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
    text(round2(landPrice), width/2, height/2);
   //text(int(Players[0].buttonPressed), width/2, height/2);
if(landPrice>0)
  landPrice -= landPrice * 0.001;

for(int i = 0; i < 5; i ++) {

drawPlayer(i);

}



}

else {
  fill(winnerColor);
  textSize(200);
  text(winner, width/2, height/2-200);
  fill(0);
  text("Získávají akcii za ", width/2, height/2);
  text(round2(landPrice) + " $", width/2, height/2+200);
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
  if(Players[index].money >= landPrice)
  fill(Players[index].onColor);
  else
  fill(Players[index].offColor);
  textSize(120);
  textAlign(CENTER, CENTER);
  text( Players[index].name,index*(width/5) + width/10, 200);
  
  fill(0);
  textSize(80);
  text( round2(Players[index].money) + " $",index*(width/5) + width/10, 300);
 

  

}
