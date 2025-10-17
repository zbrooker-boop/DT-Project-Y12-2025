extends Node2D

#Signal
signal transition_out_completed
signal transition_in_completed

#Black ColorRect for transitions 
var transition_layer : CanvasLayer
var transition_rect : ColorRect
var transition_time : float = 0.5

func _ready() -> void:
	transition_layer = CanvasLayer.new()
	transition_layer.layer = 100 
	transition_rect = ColorRect.new()
	transition_rect.color = Color.BLACK
	transition_rect.anchor_right = 1.0
	transition_rect.anchor_bottom = 1.0
	# Hide it
	transition_rect.visible = false
	transition_layer.add_child(transition_rect)
	get_tree().root.add_child(transition_layer)
	
func transition_out(effect: String = "fade"):
	match effect:
		"fade":
			_fade_out()
		_:
			_fade_out()

func transition_in(effect: String = "fade"):
	match effect:
		"fade":
			_fade_in()
		_:
			_fade_in()

func _fade_out():
	transition_rect.position = Vector2.ZERO
	transition_rect.modulate.a = 0
	transition_rect.z_index = 999
	transition_rect.visible = true
	
	var tween = create_tween()
	tween.tween_property(transition_rect, "modulate.a", 1.0, transition_time)
	tween.tween_callback(func():
		transition_out_completed.emit()
	)

func _fade_in():
	transition_rect.position = Vector2.ZERO
	transition_rect.modulate.a = 1
	transition_rect.z_index = 999
	transition_rect.visible = true
	
	var tween = create_tween()
	tween.tween_property(transition_rect, "modulate.a", 0.0, transition_time)
	tween.tween_callback(func():
		transition_rect.visible = false
		transition_in_completed.emit()
	)
