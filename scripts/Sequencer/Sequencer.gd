extends Node

onready var converters = $Converters
onready var beat2second = $Converters/Beat2SecondConverter
onready var beat2speed = $Converters/Beat2SpeedConverter
onready var beat2tick = $Converters/Beat2TickConverter
onready var second2beat = $Converters/Second2BeatConverter
onready var beat2position = $Converters/Beat2PositionConverter

var Chord = load ('res://scripts/Sequencer/Notes/Chord.gd')
var Note = load ('res://scripts/Sequencer/Notes/Note.gd')
var Hold = load ('res://scripts/Sequencer/Notes/Hold.gd')

var game = null

var bpms = null

# defaults
var speeds = [[0,1]]
var scrolls = [[0,1]]
var tickcounts = [[0,1]]
var offset = 0
var thread_count = 1

# defined in the inspector

export (NodePath) var stage_loader_path
onready var stage_loader = get_node(stage_loader_path)


onready var stepqueue = $StepQueue

func setup(stage_descriptor, data_source):
	
	stage_loader.load_stage(stage_descriptor, data_source)
	
	unpack_metadata()
	
	converters.setup()
	
	stepqueue.setup(thread_count)
	
	fill_step_queue()
	
	
	
func unpack_metadata():
	
	
	assert('bpms' in stage_loader.metadata)
	
	bpms = stage_loader.metadata.bpms
	
	# set up speeds
	if ('speeds' in stage_loader.metadata):
		speeds = stage_loader.metadata.speeds
		
	# set up scrolls
	if ('scrolls' in stage_loader.metadata):
		scrolls = stage_loader.metadata.scrolls

	# set up tickcounts
	if ('tickcounts' in stage_loader.metadata):
		tickcounts = stage_loader.metadata.tickcounts

	if ('offset' in stage_loader.metadata):
		offset = stage_loader.metadata.offset
		
	if ('thread_count' in stage_loader.metadata):
		thread_count = stage_loader.metadata.thread_count
		
	
	# modify data for continuity while interpolating curves
	scrolls.append([scrolls[-1][0]+1, scrolls[-1][1]])
	
	bpms.append([bpms[-1][0]+1, bpms[-1][1]])
	
	tickcounts.append([tickcounts[-1][0]+1, tickcounts[-1][1]])
	
	speeds.append([speeds[-1][0]+1, speeds[-1][1], 1, 0 ])


func fill_step_queue():
	
	var erase_list = []
	
	for chord in stage_loader.chord_list:
		
		if !chord.notes.empty():
		
			chord.timestamp = beat2second.scry(chord.beat)
			
			for note in chord.notes:
				note.timestamp = beat2second.scry(note.beat)
				note.distance = beat2position.scry(note.beat)
				
				if note.style == Note.STYLE.LAZYHOLD:
					
					note.end_timestamp = beat2second.scry(note.end_beat)
					
			
			stepqueue.append_chord(chord)
			
			
			
#	for chord in process_queue.chord_queue:
#		for note in chord.notes:
#			if note.style == Note.STYLE.LAZYHOLD:
#				lazyhold2lazynotes(note)

	
func lazyhold2lazynotes(hold):
	
	var current_beat = hold.beat
	var end_beat = hold.end_beat
	
	# first one out of the loop to keep it away from tick==0 behaviour
	var lazy = Note.new(Note.STYLE.LAZYNOTE, hold.type, hold.thread, current_beat)
	lazy.timestamp = beat2second.scry(current_beat)
	lazy.distance = beat2position.scry(current_beat)
	
	var chord = Chord.new(current_beat)
	chord.timestamp = lazy.timestamp
	chord.add_note(lazy)
	stepqueue.insert_chord(chord)
	


	var tick = beat2tick.scry(current_beat)
	var step = 1 / tick
	
	# correct the current_beat so all lazynotes are synchorinzed w.r.t. the beat mesh
	current_beat -= fmod(current_beat, step)
	current_beat += step
	
	# consider <= OR the endbeat exactly
	while current_beat < end_beat:
	
		tick = beat2tick.scry(current_beat)
		
		# jump to next node
		if tick == 0:
			var point = beat2tick.next_node(current_beat)
			tick = point.y
			current_beat = point.x
			continue
		
		lazy = Note.new(Note.STYLE.LAZYNOTE, hold.type, hold.thread, current_beat)
		lazy.timestamp = beat2second.scry(current_beat)
		lazy.distance = beat2position.scry(current_beat)
		
		chord = Chord.new(current_beat)
		chord.timestamp = lazy.timestamp
		chord.add_note(lazy)
		stepqueue.insert_chord(chord)
		
		step = 1 / tick
		
		current_beat += step
	




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
