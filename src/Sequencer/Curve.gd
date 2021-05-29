extends Object



var points = []

func _init():
	pass
	
	
func add_point(point):
	points.append(point)
	
	
func interpolate(offset):
	
	# generalize to the left (same slope as the first two instances)
	if offset < points[0].x:
		return linear_interpolation(points[0], points[1], offset)
	
	
	for i in range(len(points)-1):
		var a = points [i]
		var b = points[i+1]
		if ( offset >= a.x and offset < b.x):
			return linear_interpolation(a, b, offset)
			
	# generalize to the right (same slope as the last two instances)
	return linear_interpolation(points[-1], points[-2], offset)
			
		
func linear_interpolation(a, b, offset):
	
	var distance = b.x - a.x
	# interpolate
	var a_contrib = 1 - ((offset - a.x) / distance)
	var b_contrib = 1 - ((b.x- offset) / distance)
	var y = a_contrib * a.y + b_contrib * b.y
	
	return y 
	
	
func next_node(offset):
	
	# generalize to the left (same slope as the first two instances)
	if offset < points[0].x:
		return points[0]
	
	for i in range(len(points)-1):
		var a = points [i]
		var b = points[i+1]
		if ( offset >= a.x and offset < b.x):
			return b
			
	# generalize to the right (same slope as the last two instances)
	return points[-1]
	
