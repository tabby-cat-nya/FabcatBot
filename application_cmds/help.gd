extends RefCounted

var help : String = (
"meow meow! welcome to fabcat! a discord bot for Fabsoc made by Tabby <:tabby:1434381576694665378> 
`Version 0.1`
## Basic Commands
This commands can be used by anyone!
- `/help`
  displays this help screen
- `/printer-status`
  displays the currently loaded spools and nozzle for each printer
- `/spool-list`
  displays a list of both loaded and available spools

## Technician Only Commands
Since these commands edit data, only users with the `technician` role may use them
### Printer Management
- `/printer-create <name>`
  Creates a new printer with the provided name
- `/printer-delete <name>`
  Deletes the printer with the matching name
- `/printer-slots <name> <slots>`
  Changes the amount of spool slots a printer has (for example: if an AMS is attached)
- `/printer-nozzle <name> <new_nozzle>`
  Changes the nozzle attached to the printer
- `/printer-load <printer-name> <spool-name>`
  Loads a spool into a printer, If the printer only has one spool slot and it is filled then this command will replace it and return the old spool to the library (offers option to delete old spool)
- `/printer-unload <printer-name>`
  Unloads the spool from the printer, If there are multiple a dropdown asks which to unload. The unloaded spool can then be kept in the library or deleted
### Spool Management
- `/spool-create <name> [link]`
  Creates a new spool with the given name and optionally a link to it
- `/spool-delete <name>`
  Deletes the spool with the matching name, can only delete a spool if it is in the library (not loaded into a printer)
- `/spool-edit <old-name> <new-name> [new-link]`
  Changes the name and/or link of a spool, only works if the spool is in the library (not loaded into a printer)" 
)
var link : String = "\n\nInterested in improving fabcat? more information is available in the [Fabsoc docs](https://utsfabsoc.github.io/Docs/Technician-Zone/Fabcat-Discord-Bot)"

#func on_ready(main, bot: DiscordBot) -> void:
#	pass
#
#func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
#	pass

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	
	var response : String = "displaying help..."
	var embed = Embed.new().set_description(help + link) 
	embed.set_color("#CB5DFF")
	
	interaction.reply({
		"content": response,
		"embeds":[embed],
		"ephemeral" : true,
	})
	pass

var data = ApplicationCommand.new()\
	.set_name("help")\
	.set_description("read the manual")\
	
