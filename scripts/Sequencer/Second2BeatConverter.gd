extends "res://scripts/Sequencer/Converter.gd"

func setup(bpms, _converters):

	# initial position
	curve.add_point(Vector2(bpms[0][0],0))
#	print('x: ' + str(bpms[0][0]) + ' y: ' + str(0))
	
	var prev = Vector2(0,0)
	for i in range(len(bpms)-1):
		
		var current = bpms[i]
		var next = bpms[i+1]
		
		var slope = current[1] / 60 
		var seconds_per_beat = 60 / current[1]
		
		var x = (next[0] - current[0]) * seconds_per_beat + prev.x
		var y = (next[0] - current[0]) + prev.y
		
#		print('x: ' + str(x) + ' y: ' + str(y))
		curve.add_point(Vector2(x,y))
		
		prev.x = x 
		prev.y = y
		
