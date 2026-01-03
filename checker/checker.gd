extends Node


var reports_channel_id = "1433027391407788152" # channel to send admin report to

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_message_created(bot: DiscordBot, message: Message, channel: Dictionary) -> void:
	if message.author.bot:
		return
	
	## analyse every message to detect if it is a scam message or not
	# text = message.content
	# images = message.attachments - its an array, so count the attachments
	# server join date = message.member["joined_at"]
	# could also keep track of how many messages the user has sent on the server and be more sensitive if its the first 5/10/20 or so
	# message.author.id , message.author.username
	# for any matches we find, we want to senda copy to the admin channel then delete the original copy and timeout the user
	# add a check to make sure its not my own message
	# Delete Message - /channels/{channel.id}/messages/{message.id}
	# trust members after being around for 1 week + sending 20 messages?

	
	#print(message)
	print(message.guild_id)
	if message.author.id == "616872480371376128":
		# its fuzzy, lets try and time them out
		
		print(message)
		var attachment_string : String = "\n"
		if message.attachments.size()>0:
			for attach in message.attachments:
				attachment_string += attach.url + ", "
		bot.send(message, "Sorry <@" + message.author.id + "> your message was flagged as a suspected scam message, a mod will check it as soon as possible")
		bot.send(reports_channel_id, {
			"content" : "Message from <@" + message.author.id + "> detected as a scam message:\n" + message.content + attachment_string,
			#"attachments" : message.attachments,
		})
		var until = "2025-12-05T00:00:00Z"
		bot.timeout_member(message.guild_id, message.author.id, until)
		bot.delete_message(message.channel_id, message.id)
	
	
	pass # Replace with function body.
