extends Object

var items = []

var ThreadItem = load ('res://src/Sequencer/StepQueue/Threads/ThreadItem.gd')

func add_note(note, chord):
	
	var item = ThreadItem.new(note, chord)
	items.append(item)
	
func insert_note(note, chord, i):
	var item = ThreadItem.new(note, chord)
	items.insert(i, item)
	
