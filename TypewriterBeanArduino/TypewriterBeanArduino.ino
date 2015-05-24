// pin definitions (RCK is A0, which is defined in Bean Loader App pins_arduino.h)
#define _SRCLR	3
#define RCK 	18
#define SRCK 	2
#define _G 	5
#define SER_IN 	4
#define SHIFT 	1
#define LED	10

// letter definitions

#define _5	0
#define _9	1
#define _7	2
#define _6	3
#define _3	4
#define _4	5
#define _8	6
#define _2	7

#define _apost	8
#define _l	9
#define _j	10
#define _semic	11
#define _h	12
// 13 undefined
#define _return	14
#define _k	15

#define _comma	0
#define _slash	1
#define _m	2
// 3 undefined
#define _b	4
#define _space	5
#define _n	6
#define _period	7

#define _x	0
#define _f	1
#define _d	2
#define _c	3
#define _z	4
#define _v	5
#define _s	6
#define _g	7

#define _o	0
#define _i	1
#define _half	2
#define _0	3
#define _p	4
// 5 undefined
#define _backsp	6
#define _u	7


#define _q	0
#define _r	1
#define _y	2
#define _e	3
#define _a	4
#define _w	5
#define _t	6
// 7 undefined

#define _excl	1

#define _cent	1

#define _dash	1

#define _quart	1

#define _shift	1

byte inbyte = 0;
boolean active = false;
int pinSet = -1;
int pinValue = 0;
int shiftAmt = 0;
int shifted = 0; // boolean
int special = 0; // boolean
int extraTime = 0; // boolean

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

void clearAll() {
    digitalWrite(_SRCLR,0); // SRCLR low
    digitalWrite(_SRCLR,1); // SRCLR high
    digitalWrite(RCK,1); // RCK high
    digitalWrite(RCK,0); // RCK low
}

void shiftBit() {
    digitalWrite(SRCK,1); // SRCK high
    digitalWrite(SRCK,0); // SRCK low
    digitalWrite(RCK,1); // RCK high
    digitalWrite(RCK,0); // RCK low
}

void setSerIn(int value) {
  if (value==0) {
    digitalWrite(SER_IN,0);
  }
  else {
    digitalWrite(SER_IN,1);
  }
}

void setBit(int bit) {    
    // first clear
    clearAll();
    
    // shift a 1
    setSerIn(1); // SER IN high
    shiftBit();
    
    // shift bit number of 0s
    setSerIn(0); // SER IN low

    for (int i=0;i<bit;i++) {
	shiftBit(); 
    }
}

void shiftKeyOn(){
  delay(5); // wait for mechanical movement
}

void shiftKeyOff(){
}

void keystroke() {
	// set _G low
	digitalWrite(_G,0);

	// delay to allow strike
	delay(50);

	// set _G high
	digitalWrite(_G,1);	
}

void loop() {
  shifted = 0; // start with no shift
  special = 0; // not a special value (e.g., set _G, etc.)
  shiftAmt = 0;
  extraTime = 0;
  inbyte = Serial.read(); //Read one byte (one character) from serial port.
  if (inbyte != 255) {
    //Serial.write(inbyte);
    Serial.write("{");

    if (inbyte >= 'A' && inbyte <= 'Z') {
	shifted = 1;
	inbyte+=32; // converts to lowercase
    }
  
    // don't forget to handle exclamation point as special case
    switch (inbyte) {
  	case 'a':
		shiftAmt = _a;
		break;
	case 'b':
		shiftAmt = _b;
		break;
	case 'c':
		shiftAmt = _c;
		break;
	case 'd':
		shiftAmt = _d;
		break;
	case 'e':
		shiftAmt = _e;
		break;
	case 'f':
		shiftAmt = _f;
		break;
	case 'g':
		shiftAmt = _g;
		break;
	case 'h':
		shiftAmt = _h;
		break;
	case 'i':
		shiftAmt = _i;
		break;
	case 'j':
		shiftAmt = _j;
		break;
	case 'k':
		shiftAmt = _k;
		break;
	case 'l':
		shiftAmt = _l;
		break;
	case 'm':
		shiftAmt = _m;
		break;
	case 'n':
		shiftAmt = _n;
		break;
	case 'o':
		shiftAmt = _o;
		break;
	case 'p':
		shiftAmt = _p;
		break;
	case 'q':
		shiftAmt = _q;
		break;
	case 'r':
		shiftAmt = _r;
		break;
	case 's':
		shiftAmt = _s;
		break;
	case 't':
		shiftAmt = _t;
		break;
	case 'u':
		shiftAmt = _u;
		break;
	case 'v':
		shiftAmt = _v;
		break;
	case 'w':
		shiftAmt = _w;
		break;
	case 'x':
		shiftAmt = _x;
		break;
	case 'y':
		shiftAmt = _y;
		break;
	case 'z':
		shiftAmt = _z;
		break;
        case '1':
		shiftAmt = _l; // lowercase L
		break;
	case '2':
		shiftAmt = _2;
		shifted = 1;
		break;
	case '3':
		shiftAmt = _3;
		shifted = 1;
		break;
	case '4':
		shiftAmt = _4;
		shifted = 1;
		break;
	case '5':
		shiftAmt = _5;
		shifted = 1;
		break;
	case '6':
		shiftAmt = _6;
		shifted = 1;
		break;
	case '7':
		shiftAmt = _7;
		shifted = 1;
		break;
	case '8':
		shiftAmt = _8;
		shifted = 1;
		break;
	case '9':
		shiftAmt = _9;
		shifted = 1;
		break;
        case '0':
		shiftAmt = _0;
		shifted = 1;
		break;
	case '@':
		shiftAmt = _2;
		shifted = 1;
		break;
	case '#':
		shiftAmt = _3;
		shifted = 1;
		break;
	case '$':
		shiftAmt = _4;
		shifted = 1;
		break;
	case '%':
		shiftAmt = _5;
		shifted = 1;
		break;
	case '&':
		shiftAmt = _7;
		shifted = 1;
		break;
	case '*':
		shiftAmt = _8;
		shifted = 1;
		break;
	case '(':
		shiftAmt = _9;
		shifted = 1;
		break;
	case ')':
		shiftAmt = _0;
		shifted = 1;
		break;
	case '-':
		shiftAmt = _dash;
		break;
	case '_':
		shiftAmt = _dash;
		shifted = 1;
		break;
	case ';':
		shiftAmt = _semic;
		break;
	case ':':
		shiftAmt = _semic;
		shifted = 1;
		break;
	case '\'':
  		shiftAmt = _apost;
		break;
	case '"':
		shiftAmt = _apost;
		shifted = 1;
		break;
	case ',':
		shiftAmt = _comma;
		break;
	case '.':
		shiftAmt = _period;
		break;
	case '/':
		shiftAmt = _slash;
		break;
	case '?':
		shiftAmt = _slash;
		shifted = 1;
		break;
	case ' ':
		shiftAmt = _space;
		break;
	case '\n':
		shiftAmt = _return;
                extraTime = 1;
		break;
	case 127: // backspace
		shiftAmt = _backsp;
		break;
	case 'a'+127:
		special = 1;
		pinSet = _SRCLR;
    		pinValue = 1;
                break;
    	case 'b'+127:
		special = 1;
		pinSet = _SRCLR;
    		pinValue = 0;
                break;
    	case 'c'+127:
		special = 1;
		pinSet = _G;
    		pinValue = 1;
                break;
    	case 'd'+127:
		special = 1;
		pinSet = _G;
    		pinValue = 0;
                break;
    	case 'e'+127:
		special = 1;
		pinSet = RCK;
    		pinValue = 1;
                break;
    	case 'f'+127:
		special = 1;
		pinSet = RCK;
    		pinValue = 0;
                break;
    	case 'g'+127:
		special = 1;
		pinSet = SRCK;
    		pinValue = 1;
                break;
    	case 'h'+127:
		special = 1;
		pinSet = SRCK;
    		pinValue = 0;
                break;
    	case 'i'+127:
		special = 1;
		pinSet = SER_IN;
    		pinValue = 1;
                break;
    	case 'j'+127:
		special = 1;
		pinSet = SER_IN;
    		pinValue = 0;
                break;
    	case 'k'+127:
		special = 1;
		pinSet = SHIFT;
    		pinValue = 1;
                break;
    	case 'l'+127:
		special = 1;
		pinSet = SHIFT;
    		pinValue = 0;
                break;
    	case 'm'+127:
		special = 1;
		pinSet = LED;
    		pinValue = 1;
                break;
    	case 'n'+127:
		special = 1;
		pinSet = LED;
    		pinValue = 0;
                break;
        default:
                special = 1;
                pinSet = -1;
                pinValue = 1;
                Serial.write("}");
                Serial.write(inbyte);
      }

    if (special == 1) {
      if (pinSet == LED) {
    	  if (pinValue == 0) {
    	  	Bean.setLed(0,0,0);
    	  }
    	  else {
    	  	Bean.setLed(255,0,0); // red
    	  }
      }
      if (pinSet == -1) {
         // default
      }
      else {
      	digitalWrite(pinSet,pinValue);
      	Serial.write('^'); // no caret character, so just send back as special
      }
    }
    else { // regular character
    	// first, clear shift registers
    	clearAll();
  	
  	if (shifted) {
		// set shift
                shiftKeyOn();
	}
	
	setBit(shiftAmt); // set bit based on shift amount
	keystroke(); // go!

        if (extraTime) {
          delay(100);
        }
	
	if (shifted) {
		// unset shift
                shiftKeyOff();
	}
	
	// send character back for debugging purposes
	Serial.write(inbyte);
        Serial.write("]"); // other special character
    }
  }
  Bean.sleep(50);
  //delay(50);
}

