#if ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h" 
#include "pins_arduino.h"
#endif

#include "Wire.h"
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;

#define M1 4
#define E1 0
#define M2 2
#define E2 15

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
  ledcAttachPin(E,PWM); //https://randomnerdtutorials.com/esp32-pwm-arduino-ide/
  digitalWrite(motorM,dir);
}

/* Main */

void setup() {
  Serial.begin(115200);
  SerialBT.begin("Meta-Bot"); //Bluetooth device name
  Wire.begin();

  // configure LED PWM functionalitites
  ledcSetup(E1, 480, 8);
  ledcSetup(E2, 480, 8);
  
  // attach the channel to the GPIO to be controlled
  ledcAttachPin(E1, 0);
  ledcAttachPin(E2, 0);

}

void loop()
{
  
  if(READY==1){
    SerialBT.println("READY");
  }

  READY = 0;

  
  readStr = "";
  
  while (SerialBT.available()){
    if(SerialBT.available()>0){
      char c = SerialBT.read();
      readStr=c;
      
    }
  }

  SerialBT.print("Readstring is:");
  SerialBT.print(readStr);
  SerialBT.print(".\n");
  
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
