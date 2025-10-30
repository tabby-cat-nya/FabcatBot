extends Resource
class_name Printer

@export var name : String
@export var spool : Spool
@export var nozzle : String = "0.4mm"

static var nozzles : Array[String] = [
	"0.6mm",
	"0.4mm",
	"0.2mm",
]


func list_string() -> String:
	var result = name + ": "
	
	if spool:
		result += spool.name + " " 
		if spool.link:
			result += "[Link]("+spool.link+")"
	else:
		result += "***Unloaded***"
	
	result += " (Nozzle: "+nozzle+")"
	
	return result
