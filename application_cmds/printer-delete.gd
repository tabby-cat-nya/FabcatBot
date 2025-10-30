extends RefCounted

#func on_ready(main, bot: DiscordBot) -> void:
#	pass
#
func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	print(options)
	interaction.respond_autocomplete(Library.printer_choies())
	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	print(options)
	var printer_name = options[0].value
	
	for printer in Library.save.printers:
		if printer.name == printer_name:
			Library.save.printers.erase(printer)
	
	Library.save_data()
	
	var response : String = "erased printer: `" + printer_name + "`\n" 
	var embed = Embed.new().set_description(Library.list_printers()) 
	
	interaction.reply({
		"content": response,
		"embeds":[embed]
	})
	pass


var data = ApplicationCommand.new()\
	.set_name("printer-delete")\
	.set_description("remove a printer")\
	.add_option(ApplicationCommand.string_option("name", "the printers name",
	{
		"required":true,
		"autocomplete":true,
		#"choices" : Library.printer_choies()
	}))\
	
