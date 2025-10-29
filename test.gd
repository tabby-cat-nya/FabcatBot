extends Control

func _ready():
	var discord_bot = $DiscordBot
	discord_bot.TOKEN = "MTQzMzAyNTMwMzYzODQ0MjAzNQ.G3r4My.IdnvCw6xTBfoitEzvhPgxeErSDgcMCsznmLnvI"
	discord_bot.login()
	discord_bot.bot_ready.connect(_on_DiscordBot_bot_ready)
	discord_bot.message_create.connect(_on_DiscordBot_message_create)

func _on_DiscordBot_bot_ready(bot: DiscordBot):
	print("Logged in as %s#%s" % [bot.user.username, bot.user.discriminator])
	print("Listening on %d channels and %d guilds." % [bot.channels.size(), bot.guilds.size()])

func _on_DiscordBot_message_create(bot: DiscordBot, msg: Message, channel: Dictionary):
	print("New message from %s: %s" % [msg.author.username, msg.content])

	if msg.author.bot:
		return
	
	send_screenshot(bot, msg)
	
	await bot.reply(msg, "meow!")

func send_screenshot(bot: DiscordBot, msg: Message):
	var image : Image = get_viewport().get_texture().get_image()
	#image.flip_y()
	var bytes = image.save_png_to_buffer()
	
	#send
	bot.send(msg, {
		"files":[
			{
				"name" : "screenshot.png",
				"media_type" : "image/png",
				"data" : bytes
			}
		]
	})
