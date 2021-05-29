extends Node


var bpms = null
var speeds = [[0,1]]
var scrolls = [[0,1]]
var tickcounts = [[0,1]]

var offset = 0
var thread_count = 1



# [beat, position]
var beat2position = null
var second2beat = null
var beat2second = null
var beat2speed = null
var beat2tick = null


var Beat2Position = load('res://src/Sequencer/Curves/Beat2Position.gd')
var Beat2Speed = load('res://src/Sequencer/Curves/Beat2Speed.gd')
var Beat2Second = load('res://src/Sequencer/Curves/Beat2Second.gd')
var Second2Beat = load('res://src/Sequencer/Curves/Second2Beat.gd')
var Beat2Tick = load('res://src/Sequencer/Curves/Beat2Tick.gd')
var StepQueue = load('res://src/Sequencer/StepQueue/StepQueue.gd') 

var Chord = load ('res://src/Sequencer/Notes/Chord.gd')
var Note = load ('res://src/Sequencer/Notes/Note.gd')
var Hold = load ('res://src/Sequencer/Notes/Hold.gd')

var process_queue = null
var stepqueue = null

func _init(args):
	"""
	Inits the sequencer with provided parameters.
	bpms: shape(*,2)
	scrolls: shape(*,2)
	speeds: shape(*,4)
	tickcounts: shape(*,2)
	offset: float
	thread_count: uint
	"""
	# TODO: event types associated to note types
	
	assert('bpms' in args)
	
	bpms = args.bpms
	
	
	# set up speeds
	if ('speeds' in args):
		speeds = args.speeds
		
	# set up scrolls
	if ('scrolls' in args):
		scrolls = args.scrolls

	# set up tickcounts
	if ('tickcounts' in args):
		tickcounts = args.tickcounts

	if ('offset' in args):
		offset = args.offset
		
	if ('thread_count' in args):
		thread_count = args.thread_count
		
		
	
	# modify data for continuity while interpolating curves
	scrolls.append([scrolls[-1][0]+1, scrolls[-1][1]])
	
	bpms.append([bpms[-1][0]+1, bpms[-1][1]])
	
	tickcounts.append([tickcounts[-1][0]+1, tickcounts[-1][1]])
	
	speeds.append([speeds[-1][0]+1, speeds[-1][1], 1, 0 ])
	
	
	# create the stepqueue 
	stepqueue = StepQueue.new(thread_count)
	process_queue = StepQueue.new(thread_count)
	

func configure():
	
	
	beat2position = Beat2Position.new( scrolls )
	
	second2beat = Second2Beat.new( bpms )
	
	beat2second = Beat2Second.new( bpms )
	
	beat2tick = Beat2Tick.new( tickcounts )
	
	beat2speed = Beat2Speed.new( speeds,  beat2second, second2beat )
	
	# print(beat2tick.scry(112))
	
	# print(beat2second.scry(340))
	
	fill_step_queue()
	
	
	
func fill_step_queue():
	
	var erase_list = []
	
	for chord in process_queue.chord_queue:
		
		if !chord.notes.empty():
		
			chord.timestamp = beat2second.scry(chord.beat)
			
			for note in chord.notes:
				note.timestamp = beat2second.scry(note.beat)
				note.distance = beat2position.scry(note.beat)
				
				if note.style == Note.STYLE.LAZYHOLD:
					
					note.end_timestamp = beat2second.scry(note.end_beat)
					
			
			stepqueue.append_chord(chord)
			
		else:
			erase_list.append(chord)
			
			
	for chord in process_queue.chord_queue:
		for note in chord.notes:
			if note.style == Note.STYLE.LAZYHOLD:
				lazyhold2lazynotes(note)

			
	for chord in erase_list:
		process_queue.chord_queue.erase(chord)
	
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
	

func add_chord( chord ):
	
	process_queue.append_chord(chord)
	

func _ready():
	
	pass # Replace with function body.


func _process(delta):
	
	
	
	pass
