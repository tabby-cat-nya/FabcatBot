# Fabcat!
meow meow! welcome to fabcat! a discord bot for Fabsoc made by Tabby
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
  Changes the name and/or link of a spool, only works if the spool is in the library (not loaded into a printer)
## Contributing to fabcat

> [!Warning] Work in progress

fabcat is made in Godot v4.5 with the discord.gd plugin. To edit the project follow these steps:
1. Download [Godot v4.5](https://godotengine.org/download/archive/)
2. Clone the [fabcat repo](https://github.com/tabby-cat-nya/FabcatBot) to your computer 
3. Add the `.env` file with the discord bot key (ask Tabby)
4. Open the project folder with Godot

### Project Structure
- `main.gd` - main script which manages everything at the top level, you shouldn't need to touch this
- `Tools.gd` - global script that contains helper functions usable from anywhere, currently just has a function to check if the user has the right permissions 
- `AutocompleteTools.gd` - global script that contains helper functions for command autocomplete
- `library.gd` - global script that manages the printer and spool library
- `datatypes`
	- `librarySave` - class used by `library.gd` to save data to storage
	- `printer` - class used to represent a printer
	- `spool` - class used to represent a spool
- `application_cmds` - folder that holds all the commands for Fabcat, do not rename or place commands elsewhere as they will not be picked up
### Application Command Structure
Each application command file is made up of up to 5 key parts, only `execute()` and `data` are required for a minimal command:
- `on_ready()` - this function runs once when the bot starts up, useful for connecting signals
- `on_autocomplete()` - this function is run every time the bot receives a new partially typed argument and can return a list of entries for the user to pick from
- `execute()` - function that is run when the user runs the command
- `on_interaction_create()` - gets run whenever the user interacts with components in a message such as buttons or a dropdown, requires a signal connection to be made in `ready()`
- `data` - defines the structure and arguments of the application command

### Useful Resources
- [Godot Documentation](https://docs.godotengine.org/en/4.5/)
- [discord.gd Documentation](https://3ddelano.github.io/discord.gd/#quick-tips-to-browse-through-the-documentation)
- [discord.gd Youtube Tutorial](https://www.youtube.com/playlist?list=PL5t0hR7ADzuk4M_GDeGcW7cDjG_xp710p)
- [Example discord.gd Project](https://github.com/3ddelano/discord-bot-v2-godot/tree/main)

### Running an instance of fabcat
1. In Godot, select `Project -> Export...` and export the Linux build
2. This should create a few files which you should move to your server, make sure to move the `.env` file here too
3. You may need to give the `.x86_64` executable permissions 
4. run the executable with the `--headless` argument
The bot should then be running! You may want to consider creating some sort of startup task so the bot can continue if something happens to the server
