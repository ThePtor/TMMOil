void test() {
 strokeWeight(10);
 
 
stroke(204,9,47);
if(Players[0].buttonPressed) fill(204,9,47);
else fill(253,177,192);
rect(5,5,width/5-10, height-5);

stroke(255,100,24);
if(Players[1].buttonPressed) fill(255,100,24);
else fill(253,198,137);
rect(width/5 + 5,5,width/5-10, height-10);

stroke(252,225,34);
if(Players[2].buttonPressed) fill(252,225,34);
else fill(255,247,153);
rect(2*(width/5) + 5,5,width/5-10, height-10);

stroke(46,177,53);
if(Players[3].buttonPressed) fill(46,177,53);
else fill(196,223,155);
rect(3*(width/5) + 5,5,width/5-10, height-10);

stroke(0,57,166);
if(Players[4].buttonPressed) fill(0,57,166);
else fill(141,201,232);
rect(4*(width/5) + 5,5,width/5-10, height-10);

strokeWeight(1);
}
