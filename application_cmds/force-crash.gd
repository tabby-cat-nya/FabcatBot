extends RefCounted

#func on_ready(main, bot: DiscordBot) -> void:
#	pass
#
#func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
#	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	if not Tools.check_perms(interaction):
		return
	
	print("uhoh?")
	interaction.reply(
		{
			"content" : "mrowww..."
		}
	)
	print("ohhuh")
	bot.get_tree().quit()
	
	pass

var data = ApplicationCommand.new().set_name("force_crash").set_description("cause the program to quit for test purposes")
