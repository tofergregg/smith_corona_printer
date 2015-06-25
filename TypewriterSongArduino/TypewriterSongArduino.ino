// define BEAN for lightblue bean, UNO for UNO
#define UNO

// struct for a measure of 8 notes
typedef struct Measure {
  char bar[9];
} measure;

#define MEASURE_COUNT 113
//int tempo = 0.11712;
int tempo = 50;

const measure notes[MEASURE_COUNT] = {
        "eeeeeeee", // 9
        "eeeeeree", // 10
        "eeeeeeee", // 11
        "brrrcree", // 12
        "eeeeeeee", // 13
        "eeeeeree", // 14
        "eeeeeeee", // 15
        "brrrcree", // 16
        "eeeeeeee", // 17
        "eeeeeeee", // 18
        "eeeeeeee", // 19
        "brrrcree", // 20
        "eeeeeeee", // 21
        "eeeeeeee", // 22
        "eeeeeeee", // 23
        "eeeeeeee", // 24
        "errrerrr", // 25
        "brrrcree", // 26
        "eeeeeeee", // 27
        "errrcree", // 28
        "eeeeeeee", // 29
        "errrcree", // 30
        "eeeeeeee", // 31
        "eeeeerrr", // 32
        "brrrcree", // 33
        "eeeeerer", // 34
        "eeeeeeee", // 35
        "errrcree", // 36
        "eeeeeeee", // 37
        "rrrrcree", // 38
        "eeerbree", // 39
        "erbrreer", // 40
        "breeeeee", // 41
        "eeeeeeee", // 42
        "eeeeeeee", // 43
        "eeeeeree", // 44
        "eeeeeeee", // 45
        "brrrcree", // 46
        "eeeeeeee", // 47
        "eeeeeree", // 48
        "eeeeeeee", // 49
        "breecree", // 50
        "eeeeeeee", // 51
        "eeeeeeee", // 52
        "eeeeeeee", // 53
        "brrrcree", // 54
        "eeeeeeee", // 55
        "eeeeeeee", // 56
        "eeeeeeee", // 57
        "eeeeeeee", // 58
        "errrcrrr", // 59
        "rrererer", // 60 bum bum bum bum
        "rrrrbrrr", // 61
        "crereree", // 62
        "errrerer", // 63
        "rrererer", // 64
        "errrbrrr", // 65
        "crereree", // 66
        "errrerer", // 67
        "rrererer", // 68
        "errrbrbr", // 69 two bells
        "rrereree", // 70
        "errrerer", // 71
        "rrererer", // 72
        "erereeer", // 73
        "erereeer", // 74
        "erererer", // 75
        "erererer", // 76
        "errrbrrr", // 77
        "crrreree", // 78
        "errrerer", // 79
        "rrererer", // 80
        "errrbrrr", // 81
        "crereree", // 82
        "errrerer", // 83
        "rrererer", // 84
        "errrbrbr", // 85 two bells
        "rrereree", // 86
        "errrerer", // 87
        "rrererer", // 88
        "erereeer", // 89
        "erereeer", // 90
        "erererer", // 91
        "crrrrrrr", // 92
        "rrrrrrrr", // 93
        "rrrrrrrr", // 94
        "rrrrrrrr", // 95
        "rrrrrrrr", // 96
        "eeeeeeee", // 97
        "eeeeeree", // 98
        "eeeeeeee", // 99
        "brrrcree", // 100
        "eeeeeeee", // 101
        "eeeeeree", // 102
        "eeeeeeee", // 103
        "brrrcree", // 104
        "eeeeeeee", // 105
        "eeeeeeee", // 106
        "eeeeeeee", // 107
        "brrrcree", // 108
        "eeeeeeee", // 109
        "rrrrcree", // 110
        "eeeeeeee", // 111
        "errrcree", // 112
        "eeerbree", // 113
        "erbreeer", // 114
        "breeerbr", // 115
        "eeerbree", // 116
        "eeeeeeee", // 117
        "eeeeeeee", // 118
        "eeeeeeee", // 119
        "eeeeeeee", // 120
        "brrrcrrr", // 121
};

#define TOTAL_WIKI_CHARS 124

const char wikiWords[TOTAL_WIKI_CHARS] = "a_typewriter_is_a_mechanical_\
or_electromechanical_machine_\
for_writing_in_characters_\
similar_to_those_produced_by_a_\
printer.";

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
	case 127: // backspace
		shiftAmt = _backsp;
		break;
      }
      return shiftAmt;
}

void setup() {
  Serial.begin(57600); //open the serial port

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
  //delay(2);
}

void clearAll() {
    writeWithDelay(_SRCLR,0); // SRCLR low
    writeWithDelay(_SRCLR,1); // SRCLR high
    writeWithDelay(RCK,1); // RCK high
    writeWithDelay(RCK,0); // RCK low
}

void shiftBit() {
    writeWithDelay(SRCK,1); // SRCK high
    writeWithDelay(SRCK,0); // SRCK low
    writeWithDelay(RCK,1); // RCK high
    writeWithDelay(RCK,0); // RCK low
}

void setSerIn(int value) {
  if (value==0) {
    writeWithDelay(SER_IN,0);
  }
  else {
    writeWithDelay(SER_IN,1);
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
	writeWithDelay(_G,0);

	// delay to allow strike
	delay(50);

	// set _G high
	writeWithDelay(_G,1);

        // delay for actual keystroke time
        delay(50);
        
        // clear the shift register
        clearAll();
}

void playSong() {
  int wikiCount = 0;
  for (int measure_count=0;measure_count<MEASURE_COUNT;measure_count++) {
    measure m = notes[measure_count];
    for (char note = 0;note<8;note++) {
      char theNote = m.bar[note];
      if (theNote == 'e') {
        // play the "note"
        setBit(translateChar(wikiWords[wikiCount % (TOTAL_WIKI_CHARS - 1)]));
        wikiCount++;
        keystroke();
      }
      else if (theNote == 'r') {
        // rest, but still go through the motions
        setBit(_unused);
        keystroke();
      }
      else if (theNote == 'b') {
        // the bell
        setBit(_bell);
        keystroke();
      }
      else if (theNote == 'c') {
        setBit(_return);
        keystroke();
      }
      delay(tempo);
    }
  }
}

void loop() {
  inbyte = Serial.read(); //Read one byte (one character) from serial port.
  if (inbyte != 255) {
    Serial.write(inbyte);
    if (inbyte == 's') { // start playing
      playSong();
    }
    else if (inbyte == 'l') { // turn on caps lock
      setBit(_caps);
      keystroke();
    }
    // send character back for debugging purposes
    Serial.write("]"); // other special character
  }
  #ifdef BEAN
  Bean.sleep(50);
  #else
  delay(50);
  #endif
}

