extends Control

signal choice_selected

const ChoiceButtonScene = preload("res://12dt1-main-project/scenes/player_choice.tscn")

@onready var dialogue_line = %DialogueLine
@onready var speaker_name = %SpeakerName
@onready var choice_list = %ChoiceList

const ANIMATION_SPEED : int = 30
var animate_text : bool = false
var current_visable_characters : int = 0


func _ready():
	choice_list.hide()


func _process(delta):
	if animate_text:
		if dialogue_line.visible_ratio < 1:
			dialogue_line.visible_ratio += (1.0/dialogue_line.text.length()) * (ANIMATION_SPEED * delta)
			current_visable_characters = dialogue_line.visible_characters
		else: 
			animate_text = false

func change_line(speaker: String, line : String):
	speaker_name.text = speaker
	current_visable_characters = 0
	dialogue_line.text = line
	dialogue_line.visible_characters = 0
	animate_text = true

func display_choices(choices: Array):
	#Clear possible exsiting choices
	for child in choice_list.get_children():
		child.queue_free()
		
	#Buttons for the choices
	for choice in choices:
		var choice_button = ChoiceButtonScene.instantiate()
		choice_button.text = choice["text"]
		#Signal from Button
		choice_button.pressed.connect(_on_choice_button_pressed.bind(choice["goto"]))
		choice_list.add_child(choice_button)
		
	choice_list.show()

func skip_text_animation():
	dialogue_line.visible_ratio = 1

func _on_choice_button_pressed(anchor: String):
	choice_selected.emit(anchor)
	choice_list.hide()
