extends Node


onready var sequencer = $Sequencer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(stage_descriptor, data_source):
	
	sequencer.setup(stage_descriptor, data_source)
	build_note_sequence()
	

func build_note_sequence():
	pass






# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
