extends Resource
class_name Spool

@export var name : String
#@export var material : String
@export var link : String
# tags?

func list_string() -> String:
	var result : String =  name
	if link:
		result = "[" + result +"]("+link+")"
	return result
