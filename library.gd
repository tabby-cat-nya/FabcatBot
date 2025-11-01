extends Node

var save_path : String = "user://librarySave.tres"
var save : LibrarySave

# nozzles here or in save maybe?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_data():
	# check if save file exists
	print("real? " + str(FileAccess.file_exists(save_path)))
	if FileAccess.file_exists(save_path):
		print("yes, loading...")
		save = ResourceLoader.load(save_path) as LibrarySave
		print(save)
		#save = load(save_path) as GameSave
		
		
	else:
		print("nope, creating...")
		save_new()
	pass
	
func save_data():
	ResourceSaver.save(save, save_path)
	pass

func save_new():
	#data = FileAccess.open(save_path, FileAccess.WRITE_READ)
	save = LibrarySave.new()
	var error = ResourceSaver.save(save, save_path)
	print(error)

func list_printers() -> String:
	var response : String = "Current Printers:" 
	for printer : Printer in save.printers:
		response += "\n- " + printer.list_string()
	return response

func list_spools(search : String = "") -> String:
	var response : String = "Loaded Spools:"
	var unloaded_printers : int = 0
	for printer : Printer in save.printers:
		if printer.spools.size() > 0:
			response += "\n- " + printer.list_string()
		else:
			unloaded_printers += 1
	if unloaded_printers > 0:
		response += "\n-# +" + str(unloaded_printers) + " unloaded printers" 
	
	response += "\n\nAvailable Spools: "
	var found_search_match = false 
	for spool : Spool in save.spools:
		var bold : bool = false
		if spool.name == search and not found_search_match:
			bold = true
			found_search_match = true
		response += "\n- " + spool.list_string(bold)
	return response

func printer_choies() -> Array[Dictionary]:
	var printer_names : Array[Dictionary] = []
	for printer : Printer in save.printers:
		printer_names.append(ApplicationCommand.choice(printer.name, printer.name))
	return printer_names

func printer_choices_string() -> Array[String]:
	var printer_names : Array[String] = []
	for printer : Printer in save.printers:
		printer_names.append(printer.name)
	return printer_names

func spool_choices_string() -> Array[String]:
	var spool_names : Array[String] = []
	for spool : Spool in save.spools:
		spool_names.append(spool.name)
	return spool_names
