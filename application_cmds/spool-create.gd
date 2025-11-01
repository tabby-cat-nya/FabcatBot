extends RefCounted

#func on_ready(main, bot: DiscordBot) -> void:
#	pass
#
#func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
#	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	print(options)
	var spool_name : String  = options[0].value
	var spool_link : String
	if options.size() > 1:
		spool_link = options[1].value
	
	## some sort of logic to name duplicated spool differently?
	#var match_count : int = 0
	#for spool : Spool in Library.save.spools:
		#if spool.name.find(spool_name):
			#match_count += 1
	
	
	var new_spool : Spool = Spool.new()
	new_spool.name = spool_name
	if spool_link:
		new_spool.link = spool_link
	Library.save.spools.append(new_spool)
	Library.save_data()
	
	var response : String = "Created new spool: `" + spool_name + "`\n" 
	var embed = Embed.new().set_description(Library.list_spools()) 
	
	interaction.reply({
		"content": response,
		"embeds":[embed]
	})
	pass

var data = ApplicationCommand.new()\
	.set_name("spool-create")\
	.set_description("create a new spool")\
	.add_option(ApplicationCommand.string_option("name", "the printers name",{"required":true}))\
	.add_option(ApplicationCommand.string_option("link", "optional link to the fillaments page", {"required" : false}))
	
