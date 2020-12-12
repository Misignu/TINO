"""
General-Purpose Script that Pack some Classes that deals with some UI behaviors
"""

class Audio extends Node:
	"""
	General Singleton Class that deals with Audio.
	"""
	signal volume_changed
	signal mute_toggled
	
	const VOLUME_STEP = 0.1
	
	func increase_volume(channel: int = AudioServer.get_bus_index("Master")) -> void:
		set_volume(linear2db(db2linear(AudioServer.get_bus_volume_db(channel))  + VOLUME_STEP), channel)
	
	func decrease_volume(channel: int = AudioServer.get_bus_index("Master")) -> void:
		set_volume(linear2db(db2linear(AudioServer.get_bus_volume_db(channel))  - VOLUME_STEP), channel)
	
	func set_volume(value: float, channel: int = AudioServer.get_bus_index("Master")) -> void:
		
		var is_muted := AudioServer.is_bus_mute(channel)
		var mute := is_muted
		
		if value <= -80:
			
			if not is_muted:
				mute = true
			
		elif value <= 0:
			
			AudioServer.set_bus_volume_db(channel, value)
			emit_signal("volume_changed", channel, value)
			
			if is_muted:
				mute = false
		
		if is_muted != mute:
			
			mute_toggle(channel)
	
	func mute_toggle(channel: int = AudioServer.get_bus_index("Master")) -> void:
		var value = not AudioServer.is_bus_mute(channel)
		
		AudioServer.set_bus_mute(channel, value)
		emit_signal("mute_toggled", channel, value)

class Video extends Audio:
	"""
	General Singleton Class Deals with Video
	"""
	signal fullscreen_mode_changed
	signal language_changed
	signal ui_theme_toggled
	
	const LIGHT_THEME = preload("res://assets/light_theme.tres")
	const DARK_THEME = preload("res://assets/ui_theme.tres")
	
	onready var language := TranslationServer.get_locale() setget set_language, get_language
	var is_light_mode_on: bool
	
	
	func toggle_ui_theme(value: bool) -> void:
		
		emit_signal("ui_theme_toggled", LIGHT_THEME if value else DARK_THEME)
		is_light_mode_on = value
	
	
	func set_language(value: String) -> void:
		
		TranslationServer.set_locale(value)
		language = value
		emit_signal("language_changed", value)
	
	
	func set_fullscreen(mode: bool = !OS.window_fullscreen) -> void:
		
		OS.window_fullscreen = mode
		emit_signal("fullscreen_mode_changed")
	
	
	# @getters
	func get_language() -> String:
		return language
