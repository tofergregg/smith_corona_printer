#!/usr/bin/env python

import time,sys

from mingus.containers import NoteContainer, Note
from mingus.midi import fluidsynth

notes=[	"eeeeeeee", # 9
        "eeeeeree", # 10
        "eeeeeeee", # 11
        "brrrcree", # 12
        "eeeeeeee", # 13
        "eeeeeree", # 14
        "eeeeeeee", # 15
        "brrrcree", # 16
        "eeeeeeee", # 17
        "eeeeeeee", # 18
        "eeeeeeee", # 19
        "brrrcree", # 20
        "eeeeeeee", # 21
        "eeeeeeee", # 22
        "eeeeeeee", # 23
        "eeeeeeee", # 24
        "errrerrr", # 25
        "brrrcree", # 26
        "eeeeeeee", # 27
        "errrcree", # 28
        "eeeeeeee", # 29
        "errrcree", # 30
        "eeeeeeee", # 31
        "eeeeerrr", # 32
        "brrrcree", # 33
        "eeeeerer", # 34
        "eeeeeeee", # 35
        "errrcree", # 36
        "eeeeeeee", # 37
        "rrrrcree", # 38
        "eeerbree", # 39
        "erbrreer", # 40
        "breeeeee", # 41
        "eeeeeeee", # 42
        "eeeeeeee", # 43
        "eeeeeree", # 44
        "eeeeeeee", # 45
        "brrrcree", # 46
        "eeeeeeee", # 47
        "eeeeeree", # 48
        "eeeeeeee", # 49
        "breecree", # 50
        "eeeeeeee", # 51
        "eeeeeeee", # 52
        "eeeeeeee", # 53
        "brrrcree", # 54
        "eeeeeeee", # 55
        "eeeeeeee", # 56
        "eeeeeeee", # 57
        "eeeeeeee", # 58
        "errrcrrr", # 59
        "rrererer", # 60 bum bum bum bum
        "rrrrbrrr", # 61
        "crereree", # 62
        "errrerer", # 63
        "rrererer", # 64
        "errrbrrr", # 65
        "crereree", # 66
        "errrerer", # 67
        "rrererer", # 68
        "errrbrbr", # 69 two bells
        "rrereree", # 70
        "errrerer", # 71
        "rrererer", # 72
        "erereeer", # 73
        "erereeer", # 74
        "erererer", # 75
        "erererer", # 76
        "errrbrrr", # 77
        "crrreree", # 78
        "errrerer", # 79
        "rrererer", # 80
        "errrbrrr", # 81
        "crereree", # 82
        "errrerer", # 83
        "rrererer", # 84
        "errrbrbr", # 85 two bells
        "rrereree", # 86
        "errrerer", # 87
        "rrererer", # 88
        "erereeer", # 89
        "erereeer", # 90
        "erererer", # 91
        "crrrrrrr", # 92
        "rrrrrrrr", # 93
        "rrrrrrrr", # 94
        "rrrrrrrr", # 95
        "rrrrrrrr", # 96
        "eeeeeeee", # 97
        "eeeeeree", # 98
        "eeeeeeee", # 99
        "brrrcree", # 100
        "eeeeeeee", # 101
        "eeeeeree", # 102
        "eeeeeeee", # 103
        "brrrcree", # 104
        "eeeeeeee", # 105
        "eeeeeeee", # 106
        "eeeeeeee", # 107
        "brrrcree", # 108
        "eeeeeeee", # 109
        "rrrrcree", # 110
        "eeeeeeee", # 111
        "errrcree", # 112
        "eeerbree", # 113
        "erbreeer", # 114
        "breeerbr", # 115
        "eeerbree", # 116
        "eeeeeeee", # 117
        "eeeeeeee", # 118
        "eeeeeeee", # 119
        "eeeeeeee", # 120
        "brrrcrrr", # 121	
	]

strike = Note("C-4")
rest = Note("C-7") # dummy note

tempo = 0.11712

fluidsynth.init("TypewriterInstruments.sf2")

carriageReturn = {'note':40,'inst':0} # note 40, instrument 0

fluidsynth.set_instrument(1,1) # set instrument 1 as chimes
bell = {'note':72,'inst':1}

fluidsynth.set_instrument(2,3) # instrument 2 is typewriter
typewriter = {'note':50,'inst':2}

rest = {'note':100,'inst':0} # dummy note for rest

for num,measure in enumerate(notes):
	#if (num+9) < 97: continue
	sys.stdout.write(str(num+9))
	sys.stdout.flush()
	for note in measure:
		if note=="e":
			note_to_play=typewriter
		elif note == "r":
			note_to_play=rest
		elif note == "b":
			note_to_play=bell
		elif note == "c":
			note_to_play=carriageReturn
			
		fluidsynth.play_Note(note_to_play['note'],note_to_play['inst'],100)
		time.sleep(tempo)
	print


