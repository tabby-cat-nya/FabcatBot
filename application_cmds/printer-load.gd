extends RefCounted

var endangered_spool : Spool

func on_ready(main, bot: DiscordBot) -> void:
	bot.interaction_create.connect(on_interaction_create)
	pass
#
func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	print(options)
	#interaction.respond_autocomplete(Library.printer_choies())
	var result = []
	# The part of string which the user is typing
	var spool_part : String
	if options.size() > 1:
		AutocompleteTools.spool_autocomplete(options[1].value, interaction)
	else:
		AutocompleteTools.printer_autocomplete(options[0].value, interaction)
	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	if not Tools.check_perms(interaction):  #limit access to technicians only
		return
	
	print(options)
	var printer_name = options[0].value
	var printer_exists : bool = false
	var spool_name = options[1].value
	var spool_exists : bool = false
	var printer_editing : Printer
	var spool_editing : Spool
	
	for printer in Library.save.printers:
		if printer.name == printer_name:
			printer_exists = true
			printer_editing = printer
			#Library.save.printers.erase(printer)
	
	for spool in Library.save.spools:
		if spool.name == spool_name:
			spool_exists = true
			spool_editing = spool
	
	if spool_exists and printer_exists:
		if printer_editing.spool_slots <= 1:
			var printer_has_spool : bool = printer_editing.spools.size() > 0
			if printer_has_spool:
				endangered_spool = printer_editing.spools[0]
				Library.save.spools.append(endangered_spool)
				printer_editing.spools.clear()
			printer_editing.spools.append(spool_editing) 
			Library.save.spools.erase(spool_editing)
			Library.save_data()
		
			if printer_has_spool:
				#ask the user if they want to delete the old one
				var response : String = "Loaded `"+ spool_editing.name + "` into `" + printer_editing.name + "` and unloaded `" + endangered_spool.name + "` would you like to keep or delete the old spool: `" + endangered_spool.name + "` ?" 
				var embed = Embed.new().set_description(Library.list_printers()) 
				var row = MessageActionRow.new()
				var delete_button = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
				delete_button.set_custom_id('delete-oldspool')
				delete_button.set_label("Yes, delete " + endangered_spool.name)
				var keep_button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
				keep_button.set_custom_id('keep-oldspool')
				keep_button.set_label("No, keep the old spool")
				row.add_component(delete_button)
				row.add_component(keep_button)
				
				interaction.reply({
					"content": response,
					"embeds":[embed],
					"components":[row],
				})
			else:
				var response : String = "Loaded `"+ spool_editing.name + "` into `" + printer_editing.name + "`"
				var embed = Embed.new().set_description(Library.list_printers()) 
				interaction.reply({
					"content": response,
					"embeds":[embed],
				})
	
		else: #printer has multiple slots, we can only handle it if there are empty slots
			if (printer_editing.spools.size() < printer_editing.spool_slots):
				printer_editing.spools.append(spool_editing)
				Library.save.spools.erase(spool_editing)
				Library.save_data()
				var response : String = "Loaded `"+ spool_editing.name + "` into `" + printer_editing.name + "`"
				var embed = Embed.new().set_description(Library.list_printers()) 
				
				interaction.reply({
					"content": response ,
					"embeds":[embed],
				})
				
			else: #its full!!
				
				interaction.reply({
					"content": "This printer has multiple slots and they are all full, I don't know which one to replace! use `/printer-unload` to unload a spool first",
				})
				pass
	
	else:
		interaction.reply({
			"content" : "Invalid input"
		})
		return
	
	#Library.save_data()
	
	
	pass

func on_interaction_create(bot: DiscordBot, interaction : DiscordInteraction):
	if not interaction.is_button():
		return
	
	print(interaction.data.custom_id)
	
	if(interaction.data.custom_id == "delete-oldspool"):
		if not Tools.check_perms(interaction):  #limit access to technicians only
			return
		
		#print("deleting: " + endangered_printer)
		for spool in Library.save.spools:
			if spool == endangered_spool:
				Library.save.spools.erase(spool)
		Library.save_data()
		var embed = Embed.new().set_description(endangered_spool.name + " has been removed")
		endangered_spool = null
		var new_embeds = interaction.message.embeds  + [embed] 
		interaction.update({
			"content": interaction.message.content,
			"embeds": new_embeds,
			"components": []
		})
		
	elif(interaction.data.custom_id == "keep-oldspool"):
		if not Tools.check_perms(interaction):  #limit access to technicians only
			return
		
		endangered_spool = null
		var embed = Embed.new().set_description("cancelled removal")
		var new_embeds = interaction.message.embeds  + [embed] 
		interaction.update({
			"content": interaction.message.content,
			"embeds": new_embeds,
			"components": []
		})
	
	

var data = ApplicationCommand.new()\
	.set_name("printer-load")\
	.set_description("load a new spool of fillament into a printer, optionally deleting the old spool")\
	.add_option(ApplicationCommand.string_option("printer-name", "the printer to load",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	.add_option(ApplicationCommand.string_option("spool-name", "the spool to load into the printer",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	
