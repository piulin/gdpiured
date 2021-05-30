extends Node


onready var curve = $Curve

func setup(points, converters):
	pass
	
func scry(x):
	return curve.interpolate(x)
	
func next_node(x):
	return curve.next_node()
