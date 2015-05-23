byte inbyte = 0;
boolean active = false;
int pinSet = -1;
int pinValue = 0;

void setup() {
  Serial.begin(57600); //open the serial port

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
  if (inbyte != 255) {
    Serial.write(inbyte);
  }
  
  // if inbyte is a number between 1 and 48, we are going to shift a 1 to
  // that position
  // e.g., 1 would shift a 1 to position 0, and 10 would shift a 1 to position 11
  if (inbyte <= 48) {
    inbyte--; // just subtract one for actual value of shift
    pinSet = -2; // don't do anything else after this is finished
    // first clear
    digitalWrite(3,0); // SRCLR low
    
    digitalWrite(3,1); // SRCLR high
    
    digitalWrite(A0,1); // RCK high
    
    digitalWrite(A0,0); // RCK low
    
    // shift a 1
    digitalWrite(4,1); // SER IN high
    
    
    digitalWrite(2,1); // SRCK high
    
    digitalWrite(2,0); // SRCK low
    
    digitalWrite(A0,1); // RCK high
    
    digitalWrite(A0,0); // RCK low
    
    
    // shift inbyte number of 0s
    digitalWrite(4,0); // SER IN low
    

    for (int i=0;i<inbyte;i++) {
      digitalWrite(2,1); // SRCK high
      
      digitalWrite(2,0); // SRCK low
      
      digitalWrite(A0,1); // RCK high
      
      digitalWrite(A0,0); // RCK low
      
    }
    Serial.write('Z');
  }
  else if (inbyte == 'a') { 
    // set SRCLR high
    pinSet = 3;
    pinValue = 1;
  }
  
  else if (inbyte == 'b') { 
    // set SRCLR low
    pinSet = 3;
    pinValue = 0;
  }
  
  else if (inbyte == 'c') { 
    // set G high
    pinSet = 5;
    pinValue = 1;
  }
  
  else if (inbyte == 'd') { 
    // set G low
    pinSet = 5;
    pinValue = 0;
  }
  
  else if (inbyte == 'e') { 
    // set RCK high
    pinSet = A0;
    pinValue = 1;
  }
  
  else if (inbyte == 'f') { 
    // set RCK low
    pinSet = A0;
    pinValue = 0;
  }

  else if (inbyte == 'g') { 
    // set SRCK high
    pinSet = 2;
    pinValue = 1;
  }
  
  else if (inbyte == 'h') { 
    // set SRCK low
    pinSet = 2;
    pinValue = 0;
  }

  else if (inbyte == 'i') { 
    // set SER IN high
    pinSet = 4;
    pinValue = 1;
  }
  
  else if (inbyte == 'j') { 
    // set SER IN low
    pinSet = 4;
    pinValue = 0;
  }
  
  else if (inbyte == 'k') { 
    // set SHIFT high
    pinSet = 1;
    pinValue = 1;
  }
  
  else if (inbyte == 'l') { 
    // set SHIFT low
    pinSet = 1;
    pinValue = 0;
  }
  
  else if (inbyte == 'm') { 
    // turn LED red
    pinSet = -1;
    pinValue = 1;
  }
  
  else if (inbyte == 'n') { 
    // turn LED off
    pinSet = -1;
    pinValue = 0;
  }
  
  /*if (inbyte >= 'a' && inbyte <= 'n') { 
    Serial.println(inbyte); //echo the command
    Serial.print(">"); 
  }*/
  if (pinSet >= 0) {
    digitalWrite(pinSet,pinValue);
    Serial.write('X');
    pinSet = -2;
  }
  else if (pinSet == -1) {
    // must be LED
    if (pinValue == 0) {
        Bean.setLed(0,0,0);
    }
    else {
        Bean.setLed(255,0,0);
    }
  }
  //Bean.sleep(50);
  delay(1);
}

