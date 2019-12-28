extends WindowDialog

onready var tween := $Tween
onready var scroll_box := $MarginContainer/ScrollContainer
onready var show_channels_button := $MarginContainer/ScrollContainer/MarginContainer/List/ExpansiblePanel/VBoxContainer/MarginContainer/EcclodeButton
onready var full_screen_checkbox := $MarginContainer/ScrollContainer/MarginContainer/List/FullScreen/CheckBox

onready var music_mute := $MarginContainer/ScrollContainer/MarginContainer/List/ExpansiblePanel/VBoxContainer/Itens/Music/HBoxContainer/Mute
onready var sfx_mute := $MarginContainer/ScrollContainer/MarginContainer/List/ExpansiblePanel/VBoxContainer/Itens/SFXS/HBoxContainer/Mute
onready var bsfx_mute := $MarginContainer/ScrollContainer/MarginContainer/List/ExpansiblePanel/VBoxContainer/Itens/BSFXS/HBoxContainer/Mute

func _ready() -> void:
	var catch: int
	
	catch = Game.connect("mute_toggled", self, "_on_Game_mute_toggled")
	assert(catch == OK)
	catch = Game.connect("fullscreen_mode_changed", self, "_on_Game_fullScreen_mode_changed")
	assert(catch == OK)
	full_screen_checkbox.pressed = OS.window_fullscreen
	full_screen_checkbox.grab_focus()

# @signals
func _on_Game_fullScreen_mode_changed() -> void:
	full_screen_checkbox.pressed = OS.window_fullscreen

func _on_Game_mute_toggled(channel: int, value: bool) -> void:
	
	if AudioServer.get_bus_name(channel) == "Master":
		
		music_mute.disabled = value
		sfx_mute.disabled = value
		bsfx_mute.disabled = value

func _on_FullScreen_toggled(button_pressed: bool) -> void:
	
	if OS.window_fullscreen != button_pressed:
		Game.set_fullscreen(button_pressed)

func _on_FullScreen_CheckBox_focus_entered():
	$MarginContainer/ScrollContainer/MarginContainer/List/ExpansiblePanel.is_expanded = false

func _on_ExpansiblePanel_ecclosion_started():
	var music_path = $MarginContainer/ScrollContainer/MarginContainer/List/ExpansiblePanel/VBoxContainer/Itens/Music.get_path()
	
	tween.interpolate_property(scroll_box, "scroll_vertical", scroll_box.scroll_vertical, 180, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	show_channels_button.focus_next = music_path
	show_channels_button.focus_neighbour_bottom = music_path
	$MarginContainer/ScrollContainer/MarginContainer/List/ExpansiblePanel/VBoxContainer/Itens/Music/HBoxContainer/MarginContainer/HSlider.grab_focus()

func _on_ExpansiblePanel_incclosion_started():
	
	tween.stop(scroll_box, "scroll_vertical")
	tween.interpolate_property(scroll_box, "scroll_vertical", scroll_box.scroll_vertical, 0, .5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	show_channels_button.focus_next = full_screen_checkbox.get_path()
	show_channels_button.focus_neighbour_bottom = full_screen_checkbox.get_path()
