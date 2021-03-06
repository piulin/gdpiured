extends "res://scripts/Sequencer/Converter.gd"

	
func setup(speeds, converters):
	
	var beat2second = converters.beat2second
	var second2beat = converters.second2beat
	

	var prev_speed = speeds[0][1]
	for i in range(len(speeds)):
		
		var current = speeds[i]
		
		var is_seconds = true if current[3] == 1 else false
		
		var begin_transition_beat = current[0]
		var end_transition_beat = 0
		
		if is_seconds:
			var begin_second = beat2second.scry(begin_transition_beat)
			var end_second = begin_second + current[2]
			end_transition_beat = second2beat.scry(end_second) 
		else:
			end_transition_beat = begin_transition_beat + current[2]
			
		# point begin of the transition
		var x = current[0]
		var y = prev_speed
		curve.add_point(Vector2(x,y))
		
		x = end_transition_beat
		y = current[1]
		
		# point end of transition
		curve.add_point(Vector2(x,y))
		
		prev_speed = current[1]
		
