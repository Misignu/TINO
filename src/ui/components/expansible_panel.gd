tool
extends Panel

signal ecclosion_started
signal incclosion_started

var is_expanded: bool = false setget set_is_expanded


func _ready():
	
	$VBoxContainer.rect_size = rect_size
	Game.connect("ui_theme_toggled", self, "_on_Game_ui_theme_toggled")
	
	if Game.is_light_mode_on:
		theme = Game.LIGHT_THEME


# @signals
func _on_Game_ui_theme_toggled(new_theme: Theme) -> void:
	theme = new_theme


func _on_Button_pressed():
	set_is_expanded(!is_expanded)


# @main
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
