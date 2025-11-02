extends RefCounted

var endangered_printer : String = ""

func on_ready(main, bot: DiscordBot) -> void:
	bot.interaction_create.connect(on_interaction_create)
	pass
#
func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	#print(options)
	#interaction.respond_autocomplete(Library.printer_choies())
	
	# The part of string which the user is typing
	var part = options[0].value
	AutocompleteTools.printer_autocomplete(part, interaction)
	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	if not Tools.check_perms(interaction): #limit access to technicians only
		return
	
	print(options)
	var printer_name = options[0].value
	var printer_exists : bool = false
	
	for printer in Library.save.printers:
		if printer.name == printer_name:
			printer_exists = true
			endangered_printer = printer.name
			#Library.save.printers.erase(printer)
	
	#Library.save_data()
	
	if not printer_exists:
		interaction.reply({
			"content" : "unable to find " + printer_name
		})
		return
	
	var response : String = "Are you sure you want to delete: `" + printer_name + "`?\n" 
	var embed = Embed.new().set_description(Library.list_printers()) 
	var row = MessageActionRow.new()
	var delete_button = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
	delete_button.set_custom_id('delete-printer')
	delete_button.set_label("Yes, delete " + printer_name)
	var keep_button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
	keep_button.set_custom_id('keep-printer')
	keep_button.set_label("No, keep the printer")
	row.add_component(delete_button)
	row.add_component(keep_button)
	
	interaction.reply({
		"content": response,
		"embeds":[embed],
		"components":[row],
	})
	pass

func on_interaction_create(bot: DiscordBot, interaction : DiscordInteraction):
	
	
	if not interaction.is_button():
		return
	
	print(interaction.data.custom_id)
	
	if(interaction.data.custom_id == "delete-printer"):
		if not Tools.check_perms(interaction): #limit access to technicians only
			return
		#print("deleting: " + endangered_printer)
		for printer in Library.save.printers:
			if printer.name == endangered_printer:
				
				for spool : Spool in printer.spools:
					Library.save.spools.append(spool)
					#dont need to erase, the whole printers about to get obilierated
				
				Library.save.printers.erase(printer)
		Library.save_data()
		var embed = Embed.new().set_description(endangered_printer + " has been deleted")
		var new_embeds = interaction.message.embeds  + [embed] 
		interaction.update({
			"content": interaction.message.content,
			"embeds": new_embeds,
			"components": []
		})
		
	elif(interaction.data.custom_id == "keep-printer"):
		if not Tools.check_perms(interaction): #limit access to technicians only
			return
		endangered_printer = ""
		var embed = Embed.new().set_description("cancelled deletion")
		var new_embeds = interaction.message.embeds  + [embed] 
		interaction.update({
			"content": interaction.message.content,
			"embeds": new_embeds,
			"components": []
		})
	
	

var data = ApplicationCommand.new()\
	.set_name("printer-delete")\
	.set_description("remove a printer")\
	.add_option(ApplicationCommand.string_option("name", "the printers name",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	
