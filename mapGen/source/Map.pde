
float x, y;
  int offsetX, offsetY;
boolean changed;
int size = 10;
int[][] map;
boolean[][] mask;
boolean move;

void setup() {
  
map = new int[size][size];
mask = new boolean[size][size];
background(255);
size(800, 800, P2D);
}
void draw() {
    noiseDetail(int(y),0.2);
if(move){
  y = map(height - mouseY,0, height, 0, 1);
  x = map(mouseX,0, width, 0, y);
}
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
if (mask[i][j]) fill(20, 50, 200);
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
  if (!move)
mask[int(map(mouseX, 0, width, 0, size))][int(map(mouseY, 0, height, 0, size))] = !mask[int(map(mouseX, 0, width, 0, size))][int(map(mouseY, 0, height, 0, size))];
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
if (key == ' ')
noiseSeed((long)random(99999));
if (key == 'm')
move = !move;
}

}
void keyReleased() {
changed = false;
}

void saveMap() {
PrintWriter output = createWriter("../data/map.txt");
for (int i = 0; i < size; i ++){
for (int j = 0; j < size; j ++){
  if(mask[j][i])
  output.print("-1");
  else 
  output.print(map[j][i]);
  output.println();
}



}
output.flush();
output.close();


}
