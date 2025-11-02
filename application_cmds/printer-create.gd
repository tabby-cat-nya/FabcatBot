extends RefCounted

#func on_ready(main, bot: DiscordBot) -> void:
#	pass
#
#func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
#	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	if not Tools.check_perms(interaction): #limit access to technicians only
		return
	
	print(options)
	var printer_name = options[0].value
	
	var new_printer : Printer = Printer.new()
	new_printer.name = printer_name
	Library.save.printers.append(new_printer)
	Library.save_data()
	
	var response : String = "Created new printer: `" + printer_name + "`\n" 
	var embed = Embed.new().set_description(Library.list_printers()) 
	
	interaction.reply({
		"content": response,
		"embeds":[embed]
	})
	pass

var data = ApplicationCommand.new()\
	.set_name("printer-create")\
	.set_description("create a new printer")\
	.add_option(ApplicationCommand.string_option("name", "the printers name",{"required":true}))\
	
