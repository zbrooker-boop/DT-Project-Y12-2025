extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	pass

func change_character(character_name : Character.Name, is_talking : bool, expression: String):
	var character_info = Character.CHARACTER_DETAILS[character_name]
	var sprite_frames = character_info["sprite_frames"]
	var animation_name = expression
	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
		if is_talking:
			animated_sprite.play("talking") 
		else:
			animated_sprite.play("normal")
	else:
		animated_sprite.play("normal")
