extends Object


var notes = []
var beat = 0 
var timestamp = 0


func _init(beat):
	self.beat = beat

func add_note(note):
	notes.append(note)
	
