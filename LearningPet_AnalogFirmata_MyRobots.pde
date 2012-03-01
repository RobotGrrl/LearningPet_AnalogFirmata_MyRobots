/*

Learning Pet + SimpleAnalogFirmata + 
Communication to Processing + MyRobots/ThingSpeak

robotgrrl.com 
Feb. 28, 2012

*/

#include <Streaming.h>
#include <Servo.h>
#include <Firmata.h>

int led = 13;
boolean debug = true;

//--

#define  LED3_RED       2
#define  LED3_GREEN     4
#define  LED3_BLUE      3

#define  LED2_RED       5
#define  LED2_GREEN     7
#define  LED2_BLUE      6

#define  LED1_RED       8       // eyes
#define  LED1_GREEN     10      // eyes
#define  LED1_BLUE      9       // eyes

#define  SERVO1         11      // right wing
#define  SERVO2         12      // left wing
#define  SERVO3         13      // beak
#define  SERVO4         27      // rotation

#define  TOUCH_RECV     14
#define  TOUCH_SEND     15

#define  RELAY1         A0
#define  RELAY2         A1

#define  LIGHT_SENSOR   A2
#define  TEMP_SENSOR    A3

#define  BUTTON1        A6
#define  BUTTON2        A7
#define  BUTTON3        A8

#define  JOY_SWITCH     A9      // pulls line down when pressed
#define  JOY_nINT       A10     // active low interrupt input
#define  JOY_nRESET     A11     // active low reset output

#define  ULTRASONIC     A14     // ultrasonic sensor (plug 2)
#define  ANSWER_SWITCH  A13      // answer switch (plug 2)


#define  WING_R_UPPER   30;
#define  WING_R_LOWER   90;

#define  WING_L_UPPER   110
#define  WING_L_LOWER   70      // accounts for the ultrasonic sensor height

#define  BEAK_OPEN      140
#define  BEAK_CLOSED    10


Servo servos[4];

int R_start = 0;
int G_start = 0;
int B_start = 0;
int R_pre = 0;
int G_pre = 0;
int B_pre = 0;

byte analogPin = 0;

void analogWriteCallback(byte pin, int value)
{
    if (IS_PIN_PWM(pin)) {
        pinMode(PIN_TO_DIGITAL(pin), OUTPUT);
        analogWrite(PIN_TO_PWM(pin), value);
    }
}

void setup() {
  
  Firmata.setFirmwareVersion(0, 1);
  Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
  Firmata.begin(57600);

  /*
  Serial.begin(115200);
  Serial.print("\r\nStart");
  */

  pinMode(led, OUTPUT);
  digitalWrite(led, LOW);

  int p = WING_R_UPPER;
    
  servos[0].attach(SERVO1);
  servos[0].write(p);
  servos[1].attach(SERVO2);
  servos[1].write(WING_L_UPPER);

  servos[3].attach(SERVO4);
  servos[3].write(90);
  //Serial.println("servos initialized");

}

void loop() {
  
  while(Firmata.available()) {
        Firmata.processInput();
    }
    // do one analogRead per loop, so if PC is sending a lot of
    // analog write messages, we will only delay 1 analogRead
    Firmata.sendAnalog(analogPin, analogRead(analogPin)); 
    analogPin = analogPin + 1;
    if (analogPin >= TOTAL_ANALOG_PINS) analogPin = 0;
    
    updateLights();
    hotkeyAction((int)random(1, 7));
    
}

void hotkeyAction(int hotkey) {

  switch(hotkey) {
    case 1:
      openBeak(10, 5);
      break;
    case 2:
      closeBeak(10, 5);
      break;
    case 3:
      rightWing(3, 100);
      break;
    case 4:
      leftWing(3, 100);
      break;
    case 5:
      bothWings(3, 100);
      break;
    case 6:
      shake(2);
      break;
  }
  
}

