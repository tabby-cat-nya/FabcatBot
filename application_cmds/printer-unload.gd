extends RefCounted


func on_ready(main, bot: DiscordBot) -> void:
	bot.interaction_create.connect(on_interaction_create)
	pass
#
func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	#print(options)
	#interaction.respond_autocomplete(Library.printer_choies())
	
	# The part of string which the user is typing
	var part = options[0].value
	#print("received autocomplete: ", part)

	# The final Array of choices for the autocomplete response
	var result = []
	for hint in Library.printer_choices_string():
		# If the user hasn't typed anything, add all the hints
		if part == "":
			result.append(ApplicationCommand.choice(hint, hint))
		else:
			# If the user has typed some part of string,
			# add only those hints which have the part as a substring
			if hint.findn(part) > -1:
				result.append(ApplicationCommand.choice(hint, hint))

	# Limit the number of results to 25 (Discord's limit is 25)
	if result.size() > 25:
		result = result.slice(0, 24)

	# Respond with the results
	interaction.respond_autocomplete(result)
	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	print(options)
	var printer_name = options[0].value
	var printer_exists : bool = false
	var spool_name : String = ""
	
	for printer in Library.save.printers:
		if printer.name == printer_name:
			printer_exists = true
			spool_name = printer.spool.name
			Library.save.spools.append(printer.spool)
			printer.spool = null
			#Library.save.printers.erase(printer)
	
	#Library.save_data()
	
	if not printer_exists:
		interaction.reply({
			"content" : "unable to find " + printer_name
		})
		return
			
	
	
	var response : String = "returned `" + spool_name + "` to the library" 
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
	
	interaction.reply({
		"content": response,
		#"embeds":[embed],
		#"components":[row],
	})
	pass

func on_interaction_create(bot: DiscordBot, interaction : DiscordInteraction):
	if not interaction.is_button():
		return
	
	print(interaction.data.custom_id)
	
	
	
	

var data = ApplicationCommand.new()\
	.set_name("printer-unload")\
	.set_description("unload the spool from a printer and return it to the library")\
	.add_option(ApplicationCommand.string_option("name", "the printers name",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	
