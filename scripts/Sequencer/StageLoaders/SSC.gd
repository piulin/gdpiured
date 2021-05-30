extends Node



# header of the SSC file
var meta = {}

# array of meta. Each position corresponds sequentially to NOTEDATA sections
var levels = []


var Chord = load ('res://scripts/Sequencer/Notes/Chord.gd')
var Note = load ('res://scripts/Sequencer/Notes/Note.gd')
var Hold = load ('res://scripts/Sequencer/Notes/Hold.gd')


enum STEP_TYPES  {
	L_DL,
	L_UL,
	L_C,
	L_UR,
	L_DR,
	R_DL,
	R_UL,
	R_C,
	R_UR,
	R_DR
}


var pos2types = [
	STEP_TYPES.L_DL,
	STEP_TYPES.L_UL,
	STEP_TYPES.L_C,
	STEP_TYPES.L_UR,
	STEP_TYPES.L_DR,
	STEP_TYPES.R_DL,
	STEP_TYPES.R_UL,
	STEP_TYPES.R_C,
	STEP_TYPES.R_UR,
	STEP_TYPES.R_DR
	]



func metadata(level):
		
		
	# TODO: assert
	var thread_count = get_thread_count(level)
	
	var args = {
		
		bpms =  get_tag_value_of_level('BPMS',level),
		scrolls =  get_tag_value_of_level('SCROLLS',level),
		speeds =  get_tag_value_of_level('SPEEDS',level),
		offset =  get_tag_value_of_level('OFFSET',level),
		tickcounts = get_tag_value_of_level('TICKCOUNTS',level),
		thread_count = thread_count
		
	}
	
	return args
	
	
func chord_list(level):
	
	var clist = []
	
	var notedata = get_tag_value_of_level('NOTES',level)
	
	var thread_count = get_thread_count(level)
	
	var active_holds_list = []
	active_holds_list.resize(thread_count)
	
	for i in range(len(notedata)):
		
		var bar = notedata[i]
		var notes_in_bar = len(bar)
		
		for j in range(notes_in_bar):
			
			var chord_string = bar[j]
			
			var beat = (4*i + 4.0*j/notes_in_bar) ;
			
			var chord = construct_chord(chord_string, beat, active_holds_list)
			
			clist.append(chord)
		
	
	
	return clist

# TODO:
func get_thread_count(level):
	return 5 if get_tag_value_of_level('STEPSTYPE', level) == 'pump-single' else 10 
	

func construct_chord(chord_string, beat, active_holds_list):
	
	
	var chord = Chord.new(beat)
	
	for i in range(len(chord_string)):
		var c = chord_string[i]
		
		if c == '1':
			var note = Note.new(Note.STYLE.STEPNOTE, pos2types[i], i, beat)
			chord.add_note(note)
			
		elif c == '2':
			# beat_end must be initialized later.
			var hold = Hold.new(Note.STYLE.LAZYHOLD, pos2types[i], i, beat, 0)
			chord.add_note(hold)
			active_holds_list[i] = hold
			
		elif c == '3':
			var hold = active_holds_list[i]
			hold.end_beat = beat
			active_holds_list[i] = null
			
	return chord

func get_tag_value_of_level(tag, level):
	# if tag is defined in level, retrieve the custom value
	if (tag in levels[level]):
		return levels[level][tag]
	#otherwise we fallback to what's defined in the header
	else:
		return meta[tag]
