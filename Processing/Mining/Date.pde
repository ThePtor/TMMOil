

String date (int day) {
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
