extends RefCounted

var page : int = 0

func on_ready(main, bot: DiscordBot) -> void:
	bot.interaction_create.connect(on_interaction_create)
	pass

#func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
#	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	
	page = 0 # start on the first page when this command is run
	if options.size() > 0:
		page = clampi(int(options[0].value),0,get_total_pages()-1) # if a page is provided start on that page instead
	
	# need to figure out a few things 
	# 1: are there enough spools to enable pages
	
	var loaded_spools : int = 0
	for printer : Printer in Library.save.printers:
		loaded_spools += printer.spools.size()
	var num_spools : int = Library.save.spools.size() + loaded_spools
	
	var enable_pages : bool = num_spools > 25
	var total_pages : int = ceili(num_spools / float(25.0))
	var row : MessageActionRow
	if enable_pages:
		# we need buttons and the more advanced spool list
		row = make_buttons()
		pass
	
	var response : String = "Listing spools..."
	if enable_pages:
		response += " (Page "+str(page)+"/"+str(total_pages-1)+")" 
	var embed = Embed.new().set_description(Library.list_spools("", page)) 
	
	if enable_pages:
		interaction.reply({
			"content": response,
			"embeds":[embed],
			"components" : [row],
		})
	else: 
		interaction.reply({
			"content": response,
			"embeds":[embed]
		})
	
	pass

func on_interaction_create(bot: DiscordBot, interaction : DiscordInteraction):
	
	
	if not interaction.is_button():
		return
	
	print(interaction.data.custom_id)
	
	if(interaction.data.custom_id == "next-page"):
		page = clampi(page+1,0,get_total_pages()-1) 
		var row : MessageActionRow = make_buttons()
		var response = "Listing spools... (Page "+str(page)+"/"+str(get_total_pages()-1)+")"
		var embed = Embed.new().set_description(Library.list_spools("", page)) 
		
		interaction.update({
			"content": response,
			"embeds": [embed],
			"components": [row]
		})
		
	elif(interaction.data.custom_id == "prev-page"):
		page = clampi(page-1,0,get_total_pages()-1) 
		var row : MessageActionRow = make_buttons()
		var response = "Listing spools... (Page "+str(page)+"/"+str(get_total_pages()-1)+")"
		var embed = Embed.new().set_description(Library.list_spools("", page)) 
		
		interaction.update({
			"content": response,
			"embeds": [embed],
			"components": [row]
		})
	
	

func make_buttons() -> MessageActionRow:
	var row = MessageActionRow.new()
	var prev_button = MessageButton.new().set_style(MessageButton.STYLES.SECONDARY)
	prev_button.set_custom_id('prev-page')
	prev_button.set_label("⬅️ Previous Page")
	prev_button.set_disabled(page <= 0)
	var next_button = MessageButton.new().set_style(MessageButton.STYLES.SECONDARY)
	next_button.set_custom_id('next-page')
	next_button.set_label("Next Page ➡️")
	next_button.set_disabled(page >= get_total_pages()-1)
	row.add_component(prev_button)
	row.add_component(next_button)
	return row

func get_total_pages() -> int:
	var loaded_spools : int = 0
	for printer : Printer in Library.save.printers:
		loaded_spools += printer.spools.size()
	var num_spools : int = Library.save.spools.size() + loaded_spools
	return ceili(num_spools / float(25))

var data = ApplicationCommand.new()\
	.set_name("spool-list")\
	.set_description("view all current spools")\
	.add_option(ApplicationCommand.integer_option("page","display a specific page of the spool list (0 indexed)", 
	{
		"required" : false,
	}))\
	
