extends Object


enum STYLE {
	STEPNOTE,
	LAZYNOTE,
	HOLD,
	LAZYHOLD,
	REPEAT
}

enum STATUS {
	ENABLED,
	DISABLED,
	REMOVE
}

var style = null
var type = null
var beat = null
var thread = null

# used by the game logic
var properties = {}
var status =  STATUS.ENABLED


var timestamp = 0.0 setget set_timestamp, get_timestamp
var distance = 0.0 setget set_distance , get_distance

func _init(style, type, thread, beat):

	self.style = style
	self.type = type
	self.beat = beat
	self.thread = thread

	

func set_timestamp(value):
	timestamp = value
	
func get_timestamp():
	return timestamp
	
func set_distance(value):
	distance = value
	
func get_distance():
	return distance
