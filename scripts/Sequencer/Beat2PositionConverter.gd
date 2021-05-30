extends "res://scripts/Sequencer/Converter.gd"


func setup(scrolls, _converters):
	
	# initial position
	curve.add_point(Vector2(scrolls[0][0],0))
#	print('x: ' + str(scrolls[0][0]) + ' y: ' + str(0))
	
	var prev = 0
	for i in range(len(scrolls)-1):
		
		var current_scroll = scrolls[i]
		var next_scroll = scrolls[i+1]
		
		
		var x = next_scroll[0]
		var y = (next_scroll[0] - current_scroll[0]) * current_scroll[1] + prev
		
#		print('x: ' + str(x) + ' y: ' + str(y))
		curve.add_point(Vector2(x,y))
		
		prev = y
		

		
