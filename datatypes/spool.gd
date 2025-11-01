extends Resource
class_name Spool

@export var name : String
#@export var material : String
@export var link : String
# tags?

func list_string(bold : bool = false) -> String:
	var result : String =  name
	if bold:
		result = "**" + result + "**"
	if link:
		result = "[" + result +"]("+link+")"
	return result
