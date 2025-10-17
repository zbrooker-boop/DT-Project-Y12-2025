extends Node2D

@onready var character = %CharacterSprite
@onready var dialogue_ui = %DialogueUI

var transition_effect: String = "fade"
var dialogue_file: String = "res://12dt1-main-project/story/first_scene.json"
var dialogue_index : int = 0
var dialogue_lines : Array = []

func _ready():
	#Load Dialogue
	dialogue_lines = load_dialogue(dialogue_file)
	dialogue_ui.choice_selected.connect(_on_choice_selected)
	#SceneManager.transition_out_completed.connect(_on_transition_out_completed)
	#SceneManager.transition_in_completed.connect(_on_transition_in_completed)
	#Process first line of dialogue
	dialogue_index = 0
	process_current_line()


func _input(event):
	var line = dialogue_lines[dialogue_index]
	var has_choices= line.has("choices")
	if event.is_action_pressed("next_line") and not has_choices:
		if dialogue_ui.animate_text:
			dialogue_ui.skip_text_animation()
		else:
			if dialogue_index < len(dialogue_lines) - 1:
				dialogue_index += 1
				process_current_line()


func process_current_line():
	var line = dialogue_lines[dialogue_index]
	
	#Check if this is end of scene
	if line.has("next_scene"):
		var next_scene = line["next_scene"]
		dialogue_file = "res://12dt1-main-project/story/" + next_scene + ".json"
	
	#Check for location
	if line.has("location"):
		dialogue_index += 1
		process_current_line()
		return
		
	var character_name = Character.Name.You
		#Change Character expression
	if line.has("speaker"):
		character_name = Character.get_enum_from_string(line["speaker"])
	
	#Check if it's a goto command
	if line.has("goto"):
		dialogue_index = get_anchor_position(line["goto"])
		process_current_line()
		return
	
	if line.has("anchor"):
		dialogue_index += 1
		process_current_line()
		return
		
	if line.has("choices"):
		dialogue_ui.display_choices(line["choices"])
	elif line.has("text"):
		#Reading the current line of dialogue
		var speaker_name = line["speaker"]
		dialogue_ui.change_line(speaker_name, line["text"])
		var expression = ""
		if "expression" in line:
			expression = line["expression"]
		character.change_character(character_name, expression)
	else:
		dialogue_index += 1
		process_current_line()
		return

func get_anchor_position(anchor: String):
	#Find anchor point
	for i in range(dialogue_lines.size()):
		if dialogue_lines[i].has("anchor") and dialogue_lines[i]["anchor"] == anchor:
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
