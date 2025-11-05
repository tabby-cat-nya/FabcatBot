extends RefCounted

var printer_edit : Printer = null
var endangered_spool : Spool = null

func on_ready(main, bot: DiscordBot) -> void:
	bot.interaction_create.connect(on_interaction_create)
	pass
#
func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	#print(options)
	#interaction.respond_autocomplete(Library.printer_choies())
	
	# The part of string which the user is typing
	AutocompleteTools.printer_autocomplete(options[0].value, interaction)
	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	if not Tools.check_perms(interaction):  #limit access to technicians only
		return
	
	print(options)
	var printer_name = options[0].value
	var printer_exists : bool = false
	var spool_name : String = ""
	
	for printer in Library.save.printers:
		if printer.name == printer_name:
			if printer.spools.size() == 0:
				interaction.reply({
					"content": "Can't unload a spool from an empty printer",
					#"embeds":[embed],
					#"components":[row],
				})
			
			if printer.spools.size() == 1:
				var unloading_spool : Spool = printer.spools[0]
				endangered_spool = unloading_spool
				printer_exists = true
				spool_name = unloading_spool.name
				Library.save.spools.append(unloading_spool)
				printer.spools.erase(unloading_spool)
				Library.save_data()
				var response : String = "returned `" + spool_name + "` to the library, would you like to keep it there or delete it"
				#var response : String = "Loaded `"+ spool_editing.name + "` into `" + printer_editing.name + "` and unloaded `" + endangered_spool.name + "` would you like to keep or delete the old spool: `" + endangered_spool.name + "` ?" 
				var embed = Embed.new().set_description(Library.list_printers()) 
				var row = MessageActionRow.new()
				var delete_button = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
				delete_button.set_custom_id('delete-unloadspool')
				delete_button.set_label("Yes, delete " + endangered_spool.name)
				var keep_button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
				keep_button.set_custom_id('keep-unloadspool')
				keep_button.set_label("No, keep the old spool")
				row.add_component(delete_button)
				row.add_component(keep_button)
				 
				interaction.reply({
					"content": response,
					"embeds":[embed],
					"components":[row],
				})
			
			else: #printer has multiple spools loaded:
				printer_exists = true
				var response : String = "This printer has multiple spools loaded, which would you like to unload?"
				printer_edit = printer
				var menu = SelectMenu.new().set_custom_id("spool-select")
				for spool : Spool in printer.spools:
					menu.add_option(spool.name, spool.name) 
				var row = MessageActionRow.new().add_component(menu)
				var embed = Embed.new().set_description(Library.list_printers()) 
				interaction.reply({
					"content": response,
					"embeds":[embed],
					"components":[row],
				})
	
	#Library.save_data()
	
	if not printer_exists:
		interaction.reply({
			"content" : "unable to find " + printer_name
		})
		return
			
	
	
	
	#var embed = Embed.new().set_description(Library.list_printers()) 
	#var row = MessageActionRow.new()
	#var delete_button = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
	#delete_button.set_custom_id('delete-printer')
	#delete_button.set_label("Yes, delete " + printer_name)
	#var keep_button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
	#keep_button.set_custom_id('keep-printer')
	#keep_button.set_label("No, keep the printer")
	#row.add_component(delete_button)
	#row.add_component(keep_button)
	
	
	pass

func on_interaction_create(bot: DiscordBot, interaction : DiscordInteraction):
	if not (interaction.is_select_menu() or interaction.is_button()) :
		return
	
	if(interaction.data.custom_id == "spool-select"):
		if not Tools.check_perms(interaction):  #limit access to technicians only
			return
		
		print(interaction.data.values[0])
		var spool_unloading : String = interaction.data.values[0]
		for spool : Spool in printer_edit.spools:
			if spool.name == spool_unloading:
				Library.save.spools.append(spool)
				printer_edit.spools.erase(spool)
				endangered_spool = spool
				Library.save_data()
				
				#var response : String = "Loaded `"+ spool_editing.name + "` into `" + printer_editing.name + "` and unloaded `" + endangered_spool.name + "` would you like to keep or delete the old spool: `" + endangered_spool.name + "` ?" 
				#var embed = Embed.new().set_description(Library.list_printers()) 
				var row = MessageActionRow.new()
				var delete_button = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
				delete_button.set_custom_id('delete-unloadspool')
				delete_button.set_label("Yes, delete " + endangered_spool.name)
				var keep_button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
				keep_button.set_custom_id('keep-unloadspool')
				keep_button.set_label("No, keep the old spool")
				row.add_component(delete_button)
				row.add_component(keep_button)
				
				interaction.update({
					"content" : "returned `" + spool.name + "` to the library, would you like to delete it?" ,
					"components":[row],
				})
				break
				
	if(interaction.data.custom_id == "delete-unloadspool"):
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
		
	elif(interaction.data.custom_id == "keep-unloadspool"):
		if not Tools.check_perms(interaction):  #limit access to technicians only
			return
		
		endangered_spool = null
		var embed = Embed.new().set_description("spool will be kept in library")
		var new_embeds = interaction.message.embeds  + [embed] 
		interaction.update({
			"content": interaction.message.content,
			"embeds": new_embeds,
			"components": []
		})
	
	
	

var data = ApplicationCommand.new()\
	.set_name("printer-unload")\
	.set_description("unload the spool from a printer and return it to the library")\
	.add_option(ApplicationCommand.string_option("name", "the printers name",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	
