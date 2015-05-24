// pin definitions (RCK is A0, which is defined in Bean Loader App pins_arduino.h)
#define _SRCLR	3
#define RCK 	18
#define SRCK 	2
#define _G 	5
#define SER_IN 	4
#define SHIFT 	1
#define LED	10

// letter definitions
#define _a	1
#define _b	1
#define _c	1
#define _d	1
#define _e	1
#define _f	1
#define _g	1
#define _h	1
#define _i	1
#define _j	1
#define _k	1
#define _l	1
#define _m	1
#define _n	1
#define _o	1
#define _p	1
#define _q	1
#define _r	1
#define _s	1
#define _t	1
#define _u	1
#define _v	1
#define _w	1
#define _x	1
#define _y	1
#define _z	1
#define _2	7
#define _3	4
#define _4	5
#define _5	0
#define _6	3
#define _7	2
#define _8	6
#define _9	1
#define _excl	1
#define _at	1
#define _hash	1
#define _dollar	1
#define _perc	1
#define _cent	1
#define _amp	1
#define _aster	1
#define _lparen	1
#define _rparen	1
#define _dash	1
#define _uscore	1
#define _half	1
#define _quart	1
#define _semic	1
#define _colon	1
#define _apost	1
#define _quote	1
#define _comma	1
#define _period	1
#define _slash	1
#define _quest	1
#define _space	1
#define _shift	1
#define _return	1
#define _backsp	1

byte inbyte = 0;
boolean active = false;
int pinSet = -1;
int pinValue = 0;
int shift_amt = 0;
int shifted = 0; // boolean
int special = 0; // boolean

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
  shift_amt = 0;
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
		shift_amt = _a;
		break;
	case 'b':
		shift_amt = _b;
		break;
	case 'c':
		shift_amt = _c;
		break;
	case 'd':
		shift_amt = _d;
		break;
	case 'e':
		shift_amt = _e;
		break;
	case 'f':
		shift_amt = _f;
		break;
	case 'g':
		shift_amt = _g;
		break;
	case 'h':
		shift_amt = _h;
		break;
	case 'i':
		shift_amt = _i;
		break;
	case 'j':
		shift_amt = _j;
		break;
	case 'k':
		shift_amt = _k;
		break;
	case 'l':
		shift_amt = _l;
		break;
	case 'm':
		shift_amt = _m;
		break;
	case 'n':
		shift_amt = _n;
		break;
	case 'o':
		shift_amt = _o;
		break;
	case 'p':
		shift_amt = _p;
		break;
	case 'q':
		shift_amt = _q;
		break;
	case 'r':
		shift_amt = _r;
		break;
	case 's':
		shift_amt = _s;
		break;
	case 't':
		shift_amt = _t;
		break;
	case 'u':
		shift_amt = _u;
		break;
	case 'v':
		shift_amt = _v;
		break;
	case 'w':
		shift_amt = _w;
		break;
	case 'x':
		shift_amt = _x;
		break;
	case 'y':
		shift_amt = _y;
		break;
	case 'z':
		shift_amt = _z;
		break;
	case '2':
		shift_amt = _2;
		shifted = 1;
		break;
	case '3':
		shift_amt = _3;
		shifted = 1;
		break;
	case '4':
		shift_amt = _4;
		shifted = 1;
		break;
	case '5':
		shift_amt = _5;
		shifted = 1;
		break;
	case '6':
		shift_amt = _6;
		shifted = 1;
		break;
	case '7':
		shift_amt = _7;
		shifted = 1;
		break;
	case '8':
		shift_amt = _8;
		shifted = 1;
		break;
	case '9':
		shift_amt = _9;
		shifted = 1;
		break;
	case '@':
		shift_amt = _at;
		shifted = 1;
		break;
	case '#':
		shift_amt = _hash;
		shifted = 1;
		break;
	case '$':
		shift_amt = _dollar;
		shifted = 1;
		break;
	case '%':
		shift_amt = _perc;
		shifted = 1;
		break;
	case '&':
		shift_amt = _amp;
		shifted = 1;
		break;
	case '*':
		shift_amt = _aster;
		shifted = 1;
		break;
	case '(':
		shift_amt = _lparen;
		shifted = 1;
		break;
	case ')':
		shift_amt = _rparen;
		shifted = 1;
		break;
	case '-':
		shift_amt = _dash;
		break;
	case '_':
		shift_amt = _uscore;
		shifted = 1;
		break;
	case ';':
		shift_amt = _semic;
		break;
	case ':':
		shift_amt = _colon;
		shifted = 1;
		break;
	case '\'':
		shift_amt = _apost;
		break;
	case '"':
		shift_amt = _quote;
		shifted = 1;
		break;
	case ',':
		shift_amt = _comma;
		break;
	case '.':
		shift_amt = _period;
		break;
	case '/':
		shift_amt = _slash;
		break;
	case '?':
		shift_amt = _quest;
		shifted = 1;
		break;
	case ' ':
		shift_amt = _space;
		break;
	case '\n':
		shift_amt = _return;
		break;
	case 127: // backspace
		shift_amt = _backsp;
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
	
	setBit(shift_amt); // set bit based on shift amount
	keystroke(); // go!
	
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

