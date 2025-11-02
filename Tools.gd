extends Node

const personal_server_technician_rid : String = "692291233627897876"
const fabsoc_technician_rid : String = "1407246322020515892"
const fabsoc_exec_rid : String = "1038009964997914665"

func check_perms(interaction : DiscordInteraction) -> bool:
	
	print(interaction.member.roles)
	for role : String in interaction.member.roles:
		if role == fabsoc_technician_rid:
			return true
		elif role == fabsoc_exec_rid:
			return true
		elif role == personal_server_technician_rid:
			return true
		
	
	#havent found the role, sending error
	interaction.reply({
		"content" : "sorry! only users with the `technician` or `exec` role can use this command",
		"ephemeral" : true
	})
	return false
