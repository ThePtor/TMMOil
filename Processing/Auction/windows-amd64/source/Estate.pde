void estate() {
  background(255);
  textSize(200);
  fill(0);
  

if (!won){
    

for(int i = 0; i < 5; i++) {
  setButtons();
  if(Players[i].buttonPressed){
  winner = Players[i].name;
  won = true;
  break;
  }
}


    text(landPrice +" "+  winner, width/2, height/2);
   //text(int(Players[0].buttonPressed), width/2, height/2);

  landPrice -= 1000;

}

else {

  text(winner + landPrice, width/2, height/2);


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

landPrice = (int(landPrice / 1000)*1000) + 1000;

landPrice = 150000;
winner = "";


}

void finishEstate(){
for(int i = 0; i < 5; i++) {
if (Players[i].name.equals(winner))
Players[i].money -= landPrice;
savePlayers();
}



}
