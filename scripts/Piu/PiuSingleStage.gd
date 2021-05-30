extends "res://scripts/Stage.gd"



func build_note_sequence():
	for chord in sequencer.stepqueue.chord_queue:
		for note in chord.notes:
			
			print(note.distance)
