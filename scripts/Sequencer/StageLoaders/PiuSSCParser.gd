extends Node

# path to the SSC file
var path = ""
# content of the SSC file
var content = ""

# SSC bean
onready var ssc = $SSC

# keeps track of the current sentence in the SSC file
var content_idx = 0 

# array of SSC sentences
var sentences = ""

# regexs to parse the SSC file
var comment_regex = RegEx.new()
var emptyline_regex = RegEx.new()
var hashtag_regex = RegEx.new()
var semicolon_regex = RegEx.new()
var endline_regex = RegEx.new()
var carriage_return_regex = RegEx.new()
var notes_regex = RegEx.new()
var space_regex = RegEx.new()

func parse(ssc_content):
	content = ssc_content
	comment_regex.compile("//.*(\\n|\\r|\\r\\n|\\n\\r|$)")
	emptyline_regex.compile("\\s*(\\n|\\r|\\r\\n|$)")
	hashtag_regex.compile("\\s*#")
	semicolon_regex.compile(";\\s*")
	endline_regex.compile("^(\\n|\\r|\\r\\n)$")
	carriage_return_regex.compile("\\r")
	space_regex.compile("\\s*")
	notes_regex.compile('\\N+')
	
	
	parse_SSC()
	
	return ssc
	
	
	
func parse_SSC():
	
	
	# parse metadata header
	sentences = content.split(';')
	
	ssc.meta = parse_SSCSection()
	
	
	# parse NOTEDATA sections
	while content_idx < len(sentences) :
	
		var level = parse_SSCSection()
		ssc.levels.append(level)
		

# divide sections 
func stop_condition (tag):
	return tag == 'NOTEDATA'
	
# retrives the metadata of a section in the SSC file (header and NOTEDATA sections)
func parse_SSCSection():
	
	var meta = {} 
	
	for i in range (content_idx, len(sentences)):
		
		content_idx += 1
		var sentence = sentences[i]
		sentence = carriage_return_regex.sub(sentence,'')
		
		var tagValue = sentence.split(':')
		var tag = comment_regex.sub(tagValue[0], '')
		tag = hashtag_regex.sub(tag, '')
		
		tag = parse_value_meta(tag)

		# early stop if stopCondition met, or we reached the end of the file
		if stop_condition (tag):
			return post_processing( meta )
		#elif endline_regex.exec(tag) != null:
		#    return postProcessing( meta , SSCContentBySentences.length )
		if tag != '':
			var value = parse_value (tag, tagValue[1] ) 
			meta[tag] = value 
			
	return post_processing( meta ) 
	
func parse_value_meta (value):
	
	var res = comment_regex.sub(value,'')
	res = emptyline_regex.sub(res, '')
	res = hashtag_regex.sub(res, '')
	res = semicolon_regex.sub(res, '')
	
	return res

# parses sentences values
func parse_value (tag, value):
	if tag == 'NOTES':
		
		var res = comment_regex.sub(value,'', true)
		#res = space_regex.sub(res, '', true)
		#res = semicolon_regex.sub(res, '')
		
		return res
		
	else:
		return parse_value_meta( value ) ;
	
# parses sentences e.g. speeds, bpms and scrolls
func parse_comma_separated_assignments(content):
	
	var list = [] ;
	var comma_split = content.split(',') ;
	for csplit in comma_split:
		var aux = [] ;
		var equal_split = csplit.split('=')
		for esplit in equal_split:
			aux.append( float( esplit ) )
		list.append(aux) 
	return list 
	
	
# parses the note sentence
func parse_note_sentence(content):
	var measures = content.split(',')
	var out = []
	for i in range(len(measures)):
		var aux = []
		for m in notes_regex.search_all(measures[i]):
			var notes = m.get_string()
			notes = space_regex.sub(notes,'', true)
			aux.append(notes)
		out.append(aux)
	return out

	  
# process complex sentences after parsing
func post_processing(meta):

	if 'BPMS' in meta :
		meta['BPMS'] = parse_comma_separated_assignments( meta['BPMS'] ) 
		
	if 'TICKCOUNTS' in meta:
		meta['TICKCOUNTS'] = parse_comma_separated_assignments( meta['TICKCOUNTS'] ) 
		
	if 'SCROLLS' in meta :
		meta['SCROLLS'] = parse_comma_separated_assignments( meta['SCROLLS'] )
		
	if 'OFFSET' in meta:
		meta['OFFSET'] = float(meta['OFFSET']) 
		
	if 'SPEEDS' in meta:
		meta['SPEEDS'] = parse_comma_separated_assignments(meta['SPEEDS']) 
		
	if 'NOTES' in meta:
		meta['NOTES'] = parse_note_sentence(meta['NOTES'])
	
	return meta
