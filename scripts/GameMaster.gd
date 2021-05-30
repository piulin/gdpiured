extends Node

export (NodePath) var stage_path
onready var stage = get_node(stage_path)
#onready var stage = $PiuSingleStage
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	var stage_descriptor = {
		level = 0
	}
	
	var data_source = {
		ssc_content = read_content('songs/pd/A20 - Power of Dreams.ssc')
	}
	
	stage.setup(stage_descriptor, data_source)


func read_content(path):
	
	var content
	var file = File.new()
	file.open(path, File.READ)
	content = file.get_as_text()
	file.close()
	
	return content
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
