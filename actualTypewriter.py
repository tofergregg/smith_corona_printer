#!/usr/bin/env python3

import mido,readchar,sys

# setup midi
outputDevs = mido.get_output_names()
outputDev = [x for x in outputDevs if x.find('IAC') == 0][0]
output = mido.open_output(outputDev)

uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%&()' 

def charToTypewriter(key): 
    num = 0
    if 'a' <= key <= 'z':  
        num = ord(key) - ord('a') + 30
    elif key == '0':
        num = ord(key) - ord('0') + 65
    elif key == '1':
        num = 41 # lowercase l 
    elif '2' <= key <= '5':
        num = ord(key) - ord('2') + 56 
    elif '6' <= key <= '9':
        num = ord(key) - ord('6') + 61
    elif key == '\r':
        num = 83
    elif key == ' ':
        num = 84
    elif key == '\x07': # bell character, ctrl-g
        num = 60
    elif 'A' <= key <= 'Z':
        num = ord(key.lower()) - ord('a') + 30
    elif key == '+': # caps
        num = 86
    elif key == '=': # shift
        num = 87
    return num

num = 0;
print("Please start typing! (ctrl-c or ctrl-d to quit, ctrl-g for bell)")
while True:    
    key = readchar.readchar()
    if (key == '\r'):
        print()
    else:
        if key != '\x07': # ignore bell for terminal
            sys.stdout.write(key)
            sys.stdout.flush()
    if key == '\x03' or key == '\x04': # ctrl-c or ctrl-d
        break

    num = charToTypewriter(key)
    
    if key in uppercase:
        # caps lock
        output.send(mido.Message('note_on',note=86,velocity=64))

    output.send(mido.Message('note_on',note=num,velocity=64))

    if key in uppercase: 
        # shift to undo caps
        output.send(mido.Message('note_on',note=87,velocity=64))
