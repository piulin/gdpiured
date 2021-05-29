extends Object

# list of Chords
var chord_queue = []


# list of ThreadAggregation
var thread_list = []


var Chord = load ('res://src/Sequencer/Notes/Chord.gd')
var ThreadAggregation =  load ('res://src/Sequencer/StepQueue/Threads/ThreadAggregation.gd')


var thread_count = 1

func _init(thread_count):
	
	self.thread_count = thread_count
	
	for i in range(thread_count):
	
		thread_list.append(ThreadAggregation.new())
	
	

#to the end of the queue
func append_chord(chord):
	
	chord_queue.append(chord)
	
	for note in chord.notes:
		
		thread_list[note.thread].add_note(note, chord)
		
# must be sorted. If there is a chord in the same beat, then we have to merge 
# both the chord_queue and the thread_list
func insert_chord( new_chord ):
	
	if new_chord.beat > chord_queue[-1].beat:
		append_chord(new_chord)
	
	for i in range(len(chord_queue)-1):
		
		var current = chord_queue[i]
		var next = chord_queue[i+1]
		
		if  new_chord.beat >= current.beat and new_chord.beat < next.beat:
			
			# merge
			if new_chord.beat == current.beat:
				
				merge_chord(current, new_chord)
				add_chord_notes_to_threads(new_chord)
			
			# insert new chord
			else:
				chord_queue.insert(i + 1, new_chord)
				add_chord_notes_to_threads(new_chord)
				
			break
			

# into base
func merge_chord(base, target):
	
	base.notes = base.notes + target.notes
	
	
func add_chord_notes_to_threads(chord):
	
	for note in chord.notes:
		
		var aggregate = thread_list[note.thread]
		
		if note.beat > aggregate.items[-1].note.beat:
			aggregate.add_note(note,chord)
			continue
		
		for i in range(len(aggregate.items)-1):
			
			var current = aggregate.items[i]
			var next = aggregate.items[i+1]
			
			if ( note.beat >= current.note.beat and note.beat < next.note.beat):
				
				aggregate.insert_note(note, chord, i + 1)
				break
				
	
	
