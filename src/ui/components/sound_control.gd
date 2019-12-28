tool
extends MarginContainer

const CHANNELS_NAME_KEYS = ["VOLUME", "MUSIC", "ENVIRONMENT", "SFXS"]
export(int, "Master", "Music", "BSFXS", "SFXS") var channel: int setget set_channel

onready var mute_button := $HBoxContainer/Mute

func _ready():
	var catch: int
	
	_setup($HBoxContainer/MarginContainer/HSlider)
	$HBoxContainer/MarginContainer/HSlider.value = db2linear(AudioServer.get_bus_volume_db(channel))
	catch = Game.connect("language_changed", self, "_on_Game_language_changed")
	assert(catch == OK)
	catch = Game.connect("mute_toggled", self, "_on_Game_mute_toggled")
	assert(catch == OK)

# @signals
func _on_Game_language_changed(_language) -> void:
	mute_button.text = tr(CHANNELS_NAME_KEYS[channel])

func _on_Game_mute_toggled(channel_id: int, value: bool) -> void:
	
	if channel_id == channel and value != mute_button.pressed:
		mute_button.pressed = value

func _on_Mute_toggled(button_pressed: bool):
	
	if AudioServer.is_bus_mute(channel) != button_pressed:
		Game.mute_toggle(channel)

func _on_HSlider_value_changed(value: float):
	Game.set_volume(linear2db(value), channel)

# @main
static func _setup(slider: HSlider) -> void:
	
	slider.min_value = 0.0001
	slider.max_value = 1
	slider.step = 0.1

# @setters
func set_channel(value: int) -> void:
	
	$HBoxContainer/Mute.text = tr(CHANNELS_NAME_KEYS[value])
	channel = value
