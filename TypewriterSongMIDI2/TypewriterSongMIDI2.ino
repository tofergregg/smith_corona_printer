#include <MIDI.h>
// define BEAN for lightblue bean, UNO for UNO
#define UNO

//MIDI_CREATE_DEFAULT_INSTANCE();
//Defining the BaudRate used by Hairless MIDI bridge
//To use with Arduino default USB 'modem' mode
struct MySettings : midi::DefaultSettings
{
  static const long BaudRate = 115200;
};

//midi::MidiInterface<HardwareSerial,midi::DefaultSettings> myMidi(Serial);
//midi::MidiInterface<Type> Name((Type&)SerialPort)
//MIDI_CREATE_INSTANCE(HardwareSerial, Serial, MIDI);
//MIDI_CREATE_DEFAULT_INSTANCE();
MIDI_CREATE_CUSTOM_INSTANCE(HardwareSerial, Serial, MIDI, MySettings);

// struct for a measure of 8 notes
typedef struct Measure {
  char bar[9];
} measure;

int keystroke_delay = 30;

#ifdef BEAN
// pin definitions (RCK is A0, which is defined in Bean Loader App pins_arduino.h)
#define _SRCLR	3
#define RCK 	18
#define SRCK 	2
#define _G 	5
#define SER_IN 	4
#define SHIFT 	1
#define LED	10

#else
// UNO pin definitions
#define _SRCLR	12
#define RCK 	11
#define SRCK 	10
#define _G 	8
#define SER_IN 	9
#define SHIFT 	13
#define LED	13
#endif

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
#define _n	13 
#define _return	14
#define _k	15

#define _u	16
#define _period	17
#define _b	18 
#define _space	19 
#define _shift  20
#define _m	21 
#define _slash	22
#define _comma	23

#define _s	24
#define _g	25 
#define _v	26 
#define _z	27 
#define _c	28
#define _d	29 
#define _f	30
#define _x	31

#define _bell   32
#define _backsp	33
#define _o	34
#define _i	35
#define _half	36
#define _0	37
#define _p	38
#define _dash   39

#define _q	40
#define _r	41
#define _y	42
#define _e	43
#define _a	44 
#define _w	45
#define _caps   46
#define _t	47

#define _unused	48

#define _cent	1

#define _quart	1

void clearAll();

byte inbyte = 0;

int translateChar(byte inbyte) {
    int shiftAmt;
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
		break;
	case '3':
		shiftAmt = _3;
		break;
	case '4':
		shiftAmt = _4;
		break;
	case '5':
		shiftAmt = _5;
		break;
	case '6':
		shiftAmt = _6;
		break;
	case '7':
		shiftAmt = _7;
		break;
	case '8':
		shiftAmt = _8;
		break;
	case '9':
		shiftAmt = _9;
		break;
        case '0':
		shiftAmt = _0;
		break;
	case '@':
		shiftAmt = _2;
		break;
	case '#':
		shiftAmt = _3;
		break;
	case '$':
		shiftAmt = _4;
		break;
	case '%':
		shiftAmt = _5;
		break;
	case '&':
		shiftAmt = _7;
		break;
	case '*':
		shiftAmt = _8;
		break;
	case '(':
		shiftAmt = _9;
		break;
	case ')':
		shiftAmt = _0;
		break;
	case '-':
		shiftAmt = _dash;
		break;
	case '_':
		shiftAmt = _dash;
		break;
	case ';':
		shiftAmt = _semic;
		break;
	case ':':
		shiftAmt = _semic;
		break;
	case '\'':
  		shiftAmt = _apost;
		break;
	case '"':
		shiftAmt = _apost;
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
		break;
	case ' ':
		shiftAmt = _space;
		break;
	case '\n':
		shiftAmt = _return;
		break;
	case '\b': // backspace
		shiftAmt = _backsp;
		break;
        case '^': // bell
                shiftAmt = _bell;
                break;
        default:
                shiftAmt = 0;
  case '+': shiftAmt = _caps;
    break;
  case '=': shiftAmt = _shift;
  }
  return shiftAmt;
}

char pitch2char(int pitch) {
  // translates the pitch from 30 ('a') on upward based on the next string
  const char *allowed_chars="abcdefghijklmnopqrstuvwxyz2345^67890@#$%*()-_'\":;.,/?\n \b+=";
  if (pitch < 30 || pitch > 30+strlen(allowed_chars)-1) return 0; // not in range
  return allowed_chars[pitch-30];
}

void setup() {
    MIDI.setHandleNoteOn(handleNoteOn);  // Put only the name of the function

    // Initiate MIDI communications, listen to all channels
    MIDI.begin(MIDI_CHANNEL_OMNI);
  // set all pins to out
  #ifdef BEAN
  for (int i=0;i<6;i++) {
    pinMode(i,OUTPUT);
  }
  pinMode(A0,OUTPUT);
  pinMode(A1,OUTPUT);
  #else
  for (int i=8;i<=13;i++) {
    pinMode(i,OUTPUT);
  }
  pinMode(7,OUTPUT);
  pinMode(LED,OUTPUT);
  #endif
  
  // reset the shift registers (twice, for good measure)
  clearAll();
  clearAll();
  
  // set _SRCLR and _G high
  digitalWrite(_SRCLR,1);
  digitalWrite(_G,1);

  // set RCK,SRCK,SER-IN,SHIFT low
  digitalWrite(RCK,0);
  digitalWrite(SRCK,0);
  digitalWrite(SER_IN,0);
  digitalWrite(SHIFT,0);
  
  digitalWrite(A1,0);
  
}
void writeWithDelay(int pin,int value) {
  digitalWrite(pin,value);
  delay(1);
}

void clearAll() {
    digitalWrite(_SRCLR,0); // SRCLR low
    digitalWrite(_SRCLR,1); // SRCLR high
    digitalWrite(RCK,1); // RCK high
    digitalWrite(RCK,0); // RCK low
}

void shiftBit() {
    digitalWrite(SRCK,1); // SRCK high
    writeWithDelay(SRCK,0); // SRCK low
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

void keystroke() {
	// set _G low
	digitalWrite(_G,0);

	// delay to allow strike
	delay(keystroke_delay);

	// set _G high
	digitalWrite(_G,1);

        // delay for actual keystroke time
        delay(keystroke_delay);
        
        // clear the shift register
        clearAll();
}

void handleNoteOn(byte channel, byte pitch, byte velocity)
{
    // Do whatever you want when a note is pressed.

    // Try to keep your callbacks short (no delays ect)
    // otherwise it would slow down the loop() and have a bad impact
    // on real-time performance.
    char noteChar = pitch2char(pitch);
    if (noteChar == 0) return; // not a playable note
    setBit(translateChar(noteChar));
    keystroke();
}

void loop() {
  MIDI.read();
}

