extends "res://scripts/Sequencer/Loader.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func setup(points):
	var curve = FCurve.new()

	# initial position
	curve.add_point(Vector2(bpms[0][0],0))
#	print('x: ' + str(bpms[0][0]) + ' y: ' + str(0))
	
	var prev = Vector2(0,0)
	for i in range(len(bpms)-1):
		
		var current = bpms[i]
		var next = bpms[i+1]
		
		var slope = current[1] / 60 
		var seconds_per_beat = 60 / current[1]
		
		var x = next[0]
		var y = (next[0] - current[0]) * seconds_per_beat + prev.y
		
#		print('x: ' + str(x) + ' y: ' + str(y))
		curve.add_point(Vector2(x,y))
		
		prev.x = x 
		prev.y = y
		
	beat2second_curve = curve
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
