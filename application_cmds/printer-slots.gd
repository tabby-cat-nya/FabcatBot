extends RefCounted


#func on_ready(main, bot: DiscordBot) -> void:
	#pass
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
	if not Tools.check_perms(interaction):
		return
	
	print(options)
	var printer_name = options[0].value
	var new_slots : int = options[1].value
	var printer_exists : bool = false
	
	for printer in Library.save.printers:
		if printer.name == printer_name:
			printer_exists = true
			printer.spool_slots = new_slots
			#Library.save.printers.erase(printer)
	
	Library.save_data()
	
	if not printer_exists:
		interaction.reply({
			"content" : "unable to find " + printer_name
		})
		return
	
	var response : String = printer_name + " now has `" + str(new_slots) + "` spool slots\n" 
	var embed = Embed.new().set_description(Library.list_printers()) 
	
	
	interaction.reply({
		"content": response,
		"embeds":[embed],
	})
	pass


var data = ApplicationCommand.new()\
	.set_name("printer-slots")\
	.set_description("change the amount of spool slots the printer has")\
	.add_option(ApplicationCommand.string_option("name", "the printers name",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	.add_option(ApplicationCommand.integer_option("slots","number of spool slots the printer should have", 
	{
		"required" : true,
	}))\
	

## lesson learnt: option name must not have spaces
