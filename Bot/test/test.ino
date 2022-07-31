
#include "Arduino.h"
#include "Wire.h"
#include "DFRobot_MotorStepper.h"

String readStr="";
bool READY = 1;

DFRobot_Motor motor1(M1,A0);
DFRobot_Motor motor2(M3,A2);

void setup() {
  Serial.begin(115200);

  Wire.begin();

  Serial.println("Test");
  motor1.init();
  motor2.init();

}

void loop()
{
  motor1.speed(4096);
  motor2.speed(4096);
  
  if(READY==1){
    Serial.println("READY");
  }

  READY = 0;

  
  readStr = "";
  
  while (Serial.available()){
    if(Serial.available()>0){
      char c = Serial.read();
      readStr+=c;
      
    }
  }

  Serial.print("Readstring is:");
  Serial.print(readStr);
  Serial.print(".\n");
  
  if(readStr == "N"){
    
    motor1.start(CW);
    motor2.start(CW);
    delay(1000);
    motor1.stop();
    motor2.stop();

    READY = 1;

  }
  else if (readStr == "S"){

    motor1.start(CCW);
    motor2.start(CCW);
    delay(1000);
    motor1.stop();
    motor2.stop();

    READY = 1;
    
  }
  else if (readStr == "E"){

    motor1.start(CW);
    delay(2000);
    motor1.stop();
    
  }
  else if (readStr == "W"){
    motor2.start(CCW);
    delay(2000);
    motor2.stop();

    READY = 1;
  }
  else{
    motor1.stop();
    motor2.stop();

    READY = 1;
  }
  
  delay(2000);
}
