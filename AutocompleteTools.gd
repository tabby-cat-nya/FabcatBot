extends Node

func spool_autocomplete(text : String, interaction : DiscordInteraction):
	var spool_part : String = text
	print("received spool autocomplete: ", spool_part)
	# The final Array of choices for the autocomplete response
	var result = []
	for hint in Library.spool_choices_string():
		# If the user hasn't typed anything, add all the hints
		if spool_part == "":
			result.append(ApplicationCommand.choice(hint, hint))
		else:
			# If the user has typed some part of string,
			# add only those hints which have the part as a substring
			if hint.findn(spool_part) > -1:
				result.append(ApplicationCommand.choice(hint, hint))

	# Limit the number of results to 25 (Discord's limit is 25)
	if result.size() > 25:
		result = result.slice(0, 24)

	# Respond with the results
	interaction.respond_autocomplete(result)

func printer_autocomplete(text : String, interaction : DiscordInteraction):
	var part = text
	print("received autocomplete: ", part)

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

func loaded_spools_autocomplete(text : String, interaction : DiscordInteraction, spool_list : Array[Spool]):
	var part = text
	print("received autocomplete: ", part)

	var spool_choices_string : Array[String] = []
	for spool : Spool in spool_list:
		spool_choices_string.append(spool.name)

	# The final Array of choices for the autocomplete response
	var result = []
	for hint in spool_choices_string :
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
