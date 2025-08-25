extends Node2D

@onready var character = %CharacterSprite
@onready var dialogue_ui = %DialogueUI

var dialogue_index : int = 0
var dialogue_line : Array = []

func _ready():
	#Load Dialogue
	dialogue_line = load_dialogue("res://12dt1-main-project/story/second_scene.json")
	dialogue_ui.choice_selected.connect(_on_choice_selected)
	#Process first line of dialogue
	dialogue_index = 0
	process_current_line()


func _input(event):
	var line = dialogue_line[dialogue_index]
	var has_choices= line.has("choices")
	if event.is_action_pressed("next_line") and not has_choices:
		if dialogue_ui.animate_text:
			dialogue_ui.skip_text_animation()
		else:
			if dialogue_index < len(dialogue_line) - 1:
				dialogue_index += 1
				process_current_line()


func process_current_line():
	var line = dialogue_line[dialogue_index]
	#Check for location
	if line.has("location"):
		dialogue_index += 1
		process_current_line()
		return
	
	#Check if it's a goto command
	if line.has("goto"):
		dialogue_index = get_anchor_position(line["goto"])
		process_current_line()
		return
	
	if line.has("anchor"):
		dialogue_index += 1
		process_current_line()
		return
		
		#Change Character expression
	if line.has("speaker"):
		var character_name = Character.get_enum_from_string(line["speaker"])
		
	if line.has("choices"):
		dialogue_ui.display_choices(line["choices"])
	elif line.has("text"):
		#Reading the current line of dialogue
		var speaker_name = line["speaker"]
		dialogue_ui.change_line(speaker_name, line["text"])
	else:
		dialogue_index += 1
		process_current_line()
		return

func get_anchor_position(anchor: String):
	#Find anchor point
	for i in range(dialogue_line.size()):
		if dialogue_line[i].has("anchor") and dialogue_line[i]["anchor"] == anchor:
			return i
			
	print("Error: no anchor.")
	return null


func load_dialogue(file_path):
	if not FileAccess.file_exists(file_path):
		print("This file doesn't exist.")
		return null
	else:
		#Open the file
		var file =FileAccess.open(file_path, FileAccess.READ)
		#read the content as text
		var content = file.get_as_text()
		#Parse the JSON
		var json_content = JSON.parse_string(content)
		if json_content == null:
			print("Error.")
			return null
		return json_content

func _on_choice_selected(anchor: String):
	dialogue_index = get_anchor_position(anchor)
	process_current_line()
