extends Node

var save_path : String = "user://librarySave.tres"
var save : LibrarySave


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
	
