extends Resource
class_name Printer

@export var name : String
@export var spools : Array[Spool] = []
@export var nozzle : String = "0.4mm"
@export var spool_slots : int = 1

static var nozzles : Array[String] = [
	"0.6mm",
	"0.4mm",
	"0.2mm",
]


func list_string() -> String:
	var result = name + ": "
	
	if spools.size() > 0:
		for i : int in spools.size():
			result += spools[i].list_string()
			if i < spools.size() - 1:
				result += ", "
	else:
		result += "***Unloaded***"
	
	result += " (Slots: "+ str(spools.size()) +"/"+ str(spool_slots) +")"
	result += " (Nozzle: "+nozzle+")"
	
	return result
