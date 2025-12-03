extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_message_created(bot: DiscordBot, message: Message, channel: Dictionary) -> void:
	## analyse every message to detect if it is a scam message or not
	# text = message.content
	# images = message.attachments - its an array, so count the attachments
	# server join date = message.member["joined_at"]
	# could also keep track of how many messages the user has sent on the server and be more sensitive if its the first 5/10/20 or so
	# message.author.id , message.author.username
	# for any matches we find, we want to senda copy to the admin channel then delete the original copy and timeout the user
	
	#print(message)
	print(message.guild_id)
	if message.author.id == "616872480371376128":
		# its fuzzy, lets try and time them out
		var until = "2025-12-05T00:00:00Z"
		bot.timeout_member(message.guild_id, message.author.id, until)
	
	
	pass # Replace with function body.
