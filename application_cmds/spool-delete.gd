extends RefCounted

var endangered_spool : String = ""

func on_ready(main, bot: DiscordBot) -> void:
	bot.interaction_create.connect(on_interaction_create)
	pass
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
	var spool_name = options[0].value
	var spool_exists : bool = false
	
	for spool in Library.save.spools:
		if spool.name == spool_name:
			spool_exists = true
			endangered_spool = spool.name
			#Library.save.printers.erase(printer)
	
	#Library.save_data()
	
	if not spool_exists:
		interaction.reply({
			"content" : "unable to find " + spool_name
		})
		return
	
	var response : String = "Are you sure you want to delete: `" + spool_name + "`?\n" 
	#var embed = Embed.new().set_description(Library.list_spools(spool_name)) 
	var row = MessageActionRow.new()
	var delete_button = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
	delete_button.set_custom_id('delete-spool')
	delete_button.set_label("Yes, delete " + spool_name)
	var keep_button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
	keep_button.set_custom_id('keep-spool')
	keep_button.set_label("No, keep the spool")
	row.add_component(delete_button)
	row.add_component(keep_button)
	
	interaction.reply({
		"content": response,
		#"embeds":[embed],
		"components":[row],
	})
	pass

func on_interaction_create(bot: DiscordBot, interaction : DiscordInteraction):
	
	
	if not interaction.is_button():
		return
	
	print(interaction.data.custom_id)
	
	if(interaction.data.custom_id == "delete-spool"):
		if not Tools.check_perms(interaction):  #limit access to technicians only
			return
		#print("deleting: " + endangered_printer)
		for spool in Library.save.spools:
			if spool.name == endangered_spool:
				Library.save.spools.erase(spool)
				break
		Library.save_data()
		var embed = Embed.new().set_description(endangered_spool + " has been deleted")
		var new_embeds = interaction.message.embeds  + [embed] 
		interaction.update({
			"content": interaction.message.content,
			"embeds": new_embeds,
			"components": []
		})
		
	elif(interaction.data.custom_id == "keep-spool"):
		if not Tools.check_perms(interaction):  #limit access to technicians only
			return
		endangered_spool = ""
		var embed = Embed.new().set_description("cancelled deletion")
		var new_embeds = interaction.message.embeds  + [embed] 
		interaction.update({
			"content": interaction.message.content,
			"embeds": new_embeds,
			"components": []
		})
	
	

var data = ApplicationCommand.new()\
	.set_name("spool-delete")\
	.set_description("remove a spool")\
	.add_option(ApplicationCommand.string_option("name", "the name of the spool to remove",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	
