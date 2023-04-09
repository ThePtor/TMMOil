
float x, y;
  int offsetX, offsetY;
boolean changed;
int size = 10;
int[][] map;

void setup() {
  
map = new int[size][size];
background(255);
size(800, 800, P2D);
}
void draw() {
  

  y = map(height - mouseY,0, height, 0, 1);
  noiseDetail(int(y),0.2);
  x = map(mouseX,0, width, 0, y);
  background(255);
for (int i = 0; i < size; i ++){
for (int j = 0; j < size; j ++){
  map[i][j] = 3 + int(30*(noise((i+offsetX)*x,(j+offsetY)*x)));
}}
for (int i = 0; i < size; i ++){
for (int j = 0; j < size; j ++){
  if((i+j) % 2 == 0) 
fill(255);
else fill(180);
  rect(i*width/size,j*width/size,height/size,height/size);
  fill(0);
  textSize(height/(size * 2));
  strokeWeight(map[i][j]);
   textSize(map(map[i][j],3,33,30,45));
  textAlign(CENTER,CENTER);
  text(map[i][j], (i*width/size) + width/(size*2),j*height/size + height/(size*2));
  
}

}}

void mousePressed() {
noiseSeed((long)random(99999));
}

void keyPressed () {
if(!changed){
  //if (key == '+')
  //size ++;
  //  if ((key == '-')&&size > 1)
  //size --;
  
  if ((key == '\n')&&size > 1)
  saveMap();
if (key==CODED) {

if (keyCode == LEFT) {
offsetX ++;

}
if (keyCode == RIGHT) {
offsetX --;


}
if (keyCode == UP) {
offsetY ++;


}
if (keyCode == DOWN) {
offsetY --;


}}



}

}
void keyReleased() {
changed = false;
}

void saveMap() {
PrintWriter output = createWriter("map.txt");
for (int i = 0; i < size; i ++){
for (int j = 0; j < size; j ++){
  output.print(map[i][j]);
  if(j < (size - 1))
  output.print(' ');
}
output.println();


}
output.flush();
output.close();


}
