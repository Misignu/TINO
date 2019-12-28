tool
extends Panel

signal ecclosion_started
signal incclosion_started

var is_expanded: bool = false setget set_is_expanded

func _ready():
	$VBoxContainer.rect_size = rect_size

func _on_Button_pressed():
	set_is_expanded(!is_expanded)

func _resize(value: Vector2) -> void:
	
	$Tween.interpolate_property(self, "rect_min_size", rect_size, value, .3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

# @setters
func set_is_expanded(value: bool) -> void:
	
	if value:
		_resize($VBoxContainer.rect_size)
		emit_signal("ecclosion_started")
		
	else:
		_resize($VBoxContainer/MarginContainer.rect_size)
		emit_signal("incclosion_started")
	
	is_expanded = value
