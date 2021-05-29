extends Object


var FCurve = load('res://src/Sequencer/Curve.gd')

var positioning_curve = null

func _init(scrolls):
	setup(scrolls)
	
	
func setup(scrolls):
	var pos_curve = FCurve.new()
	
	# initial position
	pos_curve.add_point(Vector2(scrolls[0][0],0))
#	print('x: ' + str(scrolls[0][0]) + ' y: ' + str(0))
	
	var prev = 0
	for i in range(len(scrolls)-1):
		
		var current_scroll = scrolls[i]
		var next_scroll = scrolls[i+1]
		
		
		var x = next_scroll[0]
		var y = (next_scroll[0] - current_scroll[0]) * current_scroll[1] + prev
		
#		print('x: ' + str(x) + ' y: ' + str(y))
		pos_curve.add_point(Vector2(x,y))
		
		prev = y
		

	positioning_curve = pos_curve
		
	
func scry(beat):
	return positioning_curve.interpolate(beat)
	
