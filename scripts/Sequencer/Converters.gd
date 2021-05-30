extends Node




func setup():
	
	$Beat2PositionConverter.setup(get_parent().scrolls, null)
	$Beat2SecondConverter.setup(get_parent().bpms, null)
	$Beat2TickConverter.setup(get_parent().tickcounts, null)
	$Second2BeatConverter.setup(get_parent().bpms, null)
	
	var converters = {
		
		beat2second = $Beat2SecondConverter,
		second2beat = $Second2BeatConverter
		
	}
	
	$Beat2SpeedConverter.setup(get_parent().speeds, converters)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
