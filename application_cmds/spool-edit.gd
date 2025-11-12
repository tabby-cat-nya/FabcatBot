extends RefCounted


#func on_ready(main, bot: DiscordBot) -> void:
	#pass
#
func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	#print(options)
	#interaction.respond_autocomplete(Library.printer_choies())
	
	# The part of string which the user is typing
	var part = options[0].value
	AutocompleteTools.spool_autocomplete(part, interaction)
	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	if not Tools.check_perms(interaction):  #limit access to technicians only
		return
	
	print(options)
	var spool_name : String = options[0].value
	var new_name : String = options[1].value
	var new_link : String
	if options.size() > 2:
		new_link = options[2].value
	
	var spool_exists : bool = false
	var found_spool : Spool
	
	for spool : Spool in Library.save.spools:
		if spool.name == spool_name:
			spool_exists = true
			
			if new_name != "0":
				spool.name = new_name
			if new_link:
				spool.link = new_link
			found_spool = spool
			#Library.save.printers.erase(printer)
	
	Library.save_data()
	
	if not spool_exists:
		interaction.reply({
			"content" : "unable to find " + spool_name
		})
		return
	
	var response : String = "finished editing `" + new_name + "`"
	if found_spool:
		if found_spool.link:
			response += " [Link]("+found_spool.link+")"
	
	#var embed = Embed.new().set_description(Library.list_spools(new_name)) 
	
	
	interaction.reply({
		"content": response,
		#"embeds":[embed],
	})
	pass


var data = ApplicationCommand.new()\
	.set_name("spool-edit")\
	.set_description("edit a spool (IN THE LIBRARY)")\
	.add_option(ApplicationCommand.string_option("spool_name", "the spools name (MUST BE UNLOADED)",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	.add_option(ApplicationCommand.string_option("new_name","new name for the spool (type '0' to keep as is)", 
	{
		"required" : true,
	}))\
	.add_option(ApplicationCommand.string_option("new_link","new link for the spool", 
	{
		"required" : false,
	}))\
	

## lesson learnt: option name must not have spaces
