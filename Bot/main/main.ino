#include "Arduino.h"
#include "Wire.h"

/*
 * TODO:
 * - Integrate WiFI/ZigBee/ESP8266
 * 
 */

#define M1 4
#define E1 5
#define M2 7
#define E2 6

#define CW HIGH //Forward
#define CCW LOW //Backward
#define PWM 128 //Max PWM 255 (half dute cycle)

String readStr="";
bool READY = 1;

/* Motor Funcs */
void stop(int motorE){
  digitalWrite(motorE,LOW);
}

void move(int motorM, int dir){
  int E;
  if (motorM == M1){
    E = E1;
  }else{
    E=E2;
  }
  analogWrite(E,PWM);
  digitalWrite(motorM,dir);
}

/* Main */

void setup() {
  Serial.begin(115200);

  Wire.begin();

}

void loop()
{
  
  if(READY==1){
    Serial.println("READY");
  }

  READY = 0;

  
  readStr = "";
  
  while (Serial.available()){
    if(Serial.available()>0){
      char c = Serial.read();
      readStr=c;
      
    }
  }

  Serial.print("Readstring is:");
  Serial.print(readStr);
  Serial.print(".\n");
  
  if(readStr == "N"){
    
    move(M1,CW);
    move(M2,CW);
    delay(250);
    stop(E1);
    stop(E2);
    READY = 1;
  }
  else if (readStr == "S"){

    move(M1,CCW);
    move(M2,CCW);
    delay(250);
    stop(E1);
    stop(E2);
    READY = 1;
  }
  else if (readStr == "E"){

    move(M1,CW);
    move(M2,CCW);
    delay(250);
    stop(E1);
    stop(E2);
    READY = 1;
  }
  else{
    stop(E1);
    stop(E2);
    READY = 1;

  }

  
  
  delay(3000);
}
