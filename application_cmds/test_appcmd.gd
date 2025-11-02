extends RefCounted

#func on_ready(main, bot: DiscordBot) -> void:
#	pass
#
#func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
#	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	print("hiya!")
	interaction.reply(
		{
			"content" : "meow meow!"
		}
	)
	pass

var data = ApplicationCommand.new().set_name("meow_test").set_description("meow meow meow!")
