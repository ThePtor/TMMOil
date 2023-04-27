void test() {
 strokeWeight(10);
 
 
stroke(Players[0].onColor);
if(Players[0].buttonPressed) {fill(Players[0].onColor);}
else {fill(Players[0].offColor);}
rect(5,5,width/5-10, height-5);

stroke(Players[1].onColor);
if(Players[1].buttonPressed) fill(Players[1].onColor);
else fill(Players[1].offColor);
rect(width/5 + 5,5,width/5-10, height-10);

stroke(Players[2].onColor);
if(Players[2].buttonPressed) fill(Players[2].onColor);
else fill(Players[2].offColor);
rect(2*(width/5) + 5,5,width/5-10, height-10);

stroke(Players[3].onColor);
if(Players[3].buttonPressed) fill(Players[3].onColor);
else fill(Players[3].offColor);
rect(3*(width/5) + 5,5,width/5-10, height-10);

stroke(Players[4].onColor);
if(Players[4].buttonPressed) fill(Players[4].onColor);
else fill(Players[4].offColor);
rect(4*(width/5) + 5,5,width/5-10, height-10);

strokeWeight(1);
}
