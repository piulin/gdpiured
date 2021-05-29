
extends Spatial




# Called when the node enters the scene tree for the first time.
func _ready():
	var SSCParser = load('res://src/Parsers/SSC/SSCParser.gd')
#	var ssc_parser = SSCParser.new('res://songs/wotw/712 - Will O The Wisp.ssc')
#	var ssc_parser = SSCParser.new('res://songs/kos/1665 - Norazo - King of Sales.ssc')
	var ssc_parser = SSCParser.new('res://songs/pd/A20 - Power of Dreams.ssc')
	var ssc = ssc_parser.parse()
	
	var sequencer = ssc.set_up_sequencer(0)
	
	sequencer.configure()
	
	
	
	
	# print(ssc.levels[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
