extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	pass

func change_character(character_name : Character.Name, is_talking : bool = true):    #for animating the character sprites
	#var sprite_frames = Character.CHARACTER_DETAILS[character_name]["sprite frames"]
	#if sprite_frames:
		#animated_sprite.sprite_frames = sprite_frames
		#pass
	#else:
		#pass
	pass
