extends Node

const technician_role_id : String = "692291233627897876"

func check_perms(interaction : DiscordInteraction) -> bool:
	
	print(interaction.member.roles)
	for role : String in interaction.member.roles:
		if role == technician_role_id:
			return true
	
	#havent found the role, sending error
	interaction.reply({
		"content" : "sorry! only users with the `technician` role can use this command",
		"ephemeral" : true
	})
	return false
