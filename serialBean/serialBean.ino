/*
Terminal2Arduino
Start OS X terminal.app
Find serial device name: ls /dev/tty.*
Open terminal session: screen [serial device name] 9600 
Close session: ctrl-A ctrl-\
\ = shift-alt-7 on some keyboards
*/

#define LED 13 
byte inbyte = 0;
boolean active = false;
int pinSet = -1;
int pinValue = 0;

void setup() {
  Serial.begin(9600); //open the serial port
  pinMode(LED, OUTPUT); 
  Serial.println("Type b to start and s to stop blinking of the Arduino LED");
  Serial.print(">"); //simulate prompt
  // set all pins to out
  for (int i=0;i<6;i++) {
    pinMode(i,OUTPUT);
  }
  pinMode(A0,OUTPUT);
  pinMode(A1,OUTPUT);
  
  // set pin 7 to 0
  digitalWrite(A1,0);
}

void loop() {
  
  inbyte = Serial.read(); //Read one byte (one character) from serial port.
  if (inbyte == 'a') { 
    // set SRCLR high
    pinSet = 3;
    pinValue = 1;
  }
  
  if (inbyte == 'b') { 
    // set SRCLR low
    pinSet = 3;
    pinValue = 0;
  }
  
  if (inbyte == 'c') { 
    // set G high
    pinSet = 5;
    pinValue = 1;
  }
  
  if (inbyte == 'd') { 
    // set G low
    pinSet = 5;
    pinValue = 0;
  }
  
  if (inbyte == 'e') { 
    // set RCK high
    pinSet = A0;
    pinValue = 1;
  }
  
  if (inbyte == 'f') { 
    // set RCK low
    pinSet = A0;
    pinValue = 0;
  }

  if (inbyte == 'g') { 
    // set SRCK high
    pinSet = 2;
    pinValue = 1;
  }
  
  if (inbyte == 'h') { 
    // set SRCK low
    pinSet = 2;
    pinValue = 0;
  }

  if (inbyte == 'i') { 
    // set SER IN high
    pinSet = 4;
    pinValue = 1;
  }
  
  if (inbyte == 'j') { 
    // set SER IN low
    pinSet = 4;
    pinValue = 0;
  }
  
  if (inbyte == 'k') { 
    // set SHIFT high
    pinSet = 1;
    pinValue = 1;
  }
  
  if (inbyte == 'l') { 
    // set SHIFT low
    pinSet = 1;
    pinValue = 0;
  }
  
  if (inbyte == 'm') { 
    // turn LED red
    pinSet = -1;
    pinValue = 1;
  }
  
  if (inbyte == 'n') { 
    // turn LED off
    pinSet = -1;
    pinValue = 0;
  }
  
  if (inbyte >= 'a' && inbyte <= 'n') { 
    Serial.println(inbyte); //echo the command
    Serial.print(">"); 
  }
  if (pinSet != -1) {
    digitalWrite(pinSet,pinValue);
  }
  else {
    // must be LED
    if (pinValue == 0) {
        Bean.setLed(0,0,0);
    }
    else {
        Bean.setLed(255,0,0);
    }
  }
  Bean.sleep(100);
}

