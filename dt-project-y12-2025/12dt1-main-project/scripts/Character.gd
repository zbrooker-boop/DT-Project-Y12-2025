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
		"sprite_frames" : null
	},
	Name.Daisy: {
		"name" : "Daisy",
		"sprite_frames": preload("res://12dt1-main-project/scenes/daisy_expressions.tres")
	},
Name.Emma: {
		"name" : "Emma",
		"sprite_frames": preload("res://12dt1-main-project/scenes/emma_expressions.tres")
	}
}


static func get_enum_from_string(string_value: String) -> Name:
	if Name.has(string_value):
		return Name[string_value]
	else:
		push_error("Invaild character name.")
		return Name.You
