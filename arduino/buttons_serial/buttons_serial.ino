#include <SoftwareSerial.h>

int buttonPins[5];
int byt[8];
byte output;
void setup() {
Serial.begin(9600);
for (int i = 0; i < 5; i++){
  buttonPins[i] = i+8;
  pinMode(buttonPins[i], INPUT);
  }

}
void loop() {


for (int i = 0; i < 5; i++){
  if(digitalRead(buttonPins[i]) == HIGH) {
  byt[i] = 1;}
  else {byt[i] = 0;}
  }
output = 0;
int power = 1;
for (int i = 0; i < 8; i++){
  power = 1;
  for(int j = 0; j < i; j++){
    power = power *2;
    }

output += (byt[i] * (power));
 
}
Serial.println(char(output));

delay(100);
}
