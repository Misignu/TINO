extends CanvasLayer

const NEXT_SCENE = "res://src/scenarios/world_map.tscn"
const ANIM = "out"

onready var options: WindowDialog = $Options


func _ready():
	$MainMenu/VBoxContainer/MenuOptions/NewGame.grab_focus()


# @signals
func _on_NewGame_pressed():
	
	$MainMenu/Transition.play(ANIM)
	$Audio/Music.stop()
	OS.clipboard = "Obrigado por jogar!   #Ludart" # HACKER DEMAIS


func _on_Continue_pressed():
	
	if OS.is_debug_build():
		
		print("Not implemented!\nThis is just for learning basic stuff folk XD")
		OS.window_minimized = true
	
	$Audio/NotImplementedSFX.play()


func _on_Options_pressed():
	
	$PauseBreak.set_process_input(false)
	options.popup()


func _on_Options_popup_hide() -> void:
	$PauseBreak.set_process_input(true)


func _on_PauseBreak_popup_overlay_hidded() -> void:
	
	$MainMenu/VBoxContainer/MenuOptions/NewGame.grab_focus()


func _on_Transition_animation_finished(anim_name: String):
	var catch: int
	
	if anim_name == ANIM:
		
		catch = get_tree().change_scene(NEXT_SCENE)
		assert(catch == OK)
