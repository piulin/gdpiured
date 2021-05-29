extends Object


var FCurve = load('res://src/Sequencer/Curve.gd')

var beat2tick_curve = null

func _init(tickcounts):
	setup(tickcounts)
	
	
func setup(tickcounts):
	var curve = FCurve.new()

	for i in range(len(tickcounts)-1):
		
		var current = tickcounts[i]
		var next = tickcounts[i+1]
		
		
		curve.add_point(Vector2(current[0],current[1]))
#		print('x: ' + str(current[0]) + ' y: ' + str(current[1]))
		curve.add_point(Vector2(next[0],current[1]))
#		print('x: ' + str(next[0]) + ' y: ' + str(current[1]))
		
		
		
	beat2tick_curve = curve
	
func scry(beat):
	return beat2tick_curve.interpolate(beat)
	
func next_node(beat):
	return beat2tick_curve.next_node(beat)
	
