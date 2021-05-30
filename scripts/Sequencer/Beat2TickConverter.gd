extends "res://scripts/Sequencer/Converter.gd"

func setup(tickcounts, _converters):

	for i in range(len(tickcounts)-1):
		
		var current = tickcounts[i]
		var next = tickcounts[i+1]
		
		
		curve.add_point(Vector2(current[0],current[1]))
#		print('x: ' + str(current[0]) + ' y: ' + str(current[1]))
		curve.add_point(Vector2(next[0],current[1]))
#		print('x: ' + str(next[0]) + ' y: ' + str(current[1]))
		
