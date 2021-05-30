extends "res://scripts/Sequencer/StageLoader.gd"


onready var parser = $PiuParser
onready var ssc = $PiuParser/SSC

func load_stage(stage_descriptor, data_source):
	
	var level = stage_descriptor.level
	
	var content = data_source.ssc_content
	
	parser.parse(content)
	
	metadata = ssc.metadata(level)
	chord_list = ssc.chord_list(level)
	
	
