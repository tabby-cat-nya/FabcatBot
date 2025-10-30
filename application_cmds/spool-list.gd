extends RefCounted

#func on_ready(main, bot: DiscordBot) -> void:
#	pass
#
#func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
#	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	
	var response : String = "Listing spools..." 
	var embed = Embed.new().set_description(Library.list_spools()) 
	
	interaction.reply({
		"content": response,
		"embeds":[embed]
	})
	pass

var data = ApplicationCommand.new()\
	.set_name("spool-list")\
	.set_description("view all current spools")\
	
