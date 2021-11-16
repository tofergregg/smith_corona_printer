# Smith Corona Typewriter to Printer Project
This project aims to convert a 1960s Smith Corona Sterling Automatic 12
typewriter into a printer using solenoids, circuits, and code.

To set up midi:

1. Open Hairless-MIDI Serial Bridge
2. Connect Serial port to USB (may be "USB ACM" for Genuine Arduino)
3. Should have MIDI In set to "IAC Driver Bus 1" and MIDI Out set to "(Not Connected)"
4. Open Melody Assistant
5. Instruments->Relate Output Device, set Helicopter and Car Engine to MIDI 1
6. If necessary, test MIDI output with Configuration->MIDI Configuration,
   MIDI output 1 should be set to Bus 1, and then Test
7. Set to 115,200 Baud, N81
8. For actualTypewriter.py: need to pip install python-rtmidi (and others)

Correct Arduino file: TypewriterSongMIDI2

Song for Melody Assistant: typewriterFluteHighQ2_typewriter.myr

