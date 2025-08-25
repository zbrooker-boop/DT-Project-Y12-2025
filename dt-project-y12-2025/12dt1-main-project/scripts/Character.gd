class_name Character
extends Node

enum Name {
	You,
	Daisy,
	Emma
}

const CHARACTER_DETAILS : Dictionary = {
	Name.You: {
		"name" : "You",
		"gender" : "female",
		"sprite_frames" : null
	},
	Name.Daisy: {
		"name" : "character1",
		"gender" : "female",
	},
Name.Emma: {
		"name" : "character2",
		"gender" : "female",
	}
}


static func get_enum_from_string(string_value: String) -> Name:
	if Name.has(string_value):
		return Name[string_value]
	else:
		push_error("Invaild character name.")
		return Name.You
