extends CanvasLayer
const NEXT_SCENE = "res://hud/menus/player_selection.tscn"

func _ready():
	
	$MainMenu/VBoxContainer/MenuOptions/NewGame.grab_focus()

# @signals
func _on_Transition_animation_finished(anim_name):
	
	if anim_name == "out":
		
		Game.set_transparency_mode()
		assert(get_tree().change_scene(NEXT_SCENE) == OK)


func _on_NewGame_pressed():
	
	$MainMenu/Transition.play("out")
	$Audio/Music.stop()
	OS.clipboard = "Obrigado por jogar! ������" # WATCH -> HACKER DEMAIS

func _on_Continue_pressed():
	
	print("Not implemented!\nThis is just for learning basic stuff folk XD")
	OS.window_minimized = true
	$Audio/NotImplementedSFX.play()

func _on_Options_pressed():
	
	$Options.popup()
	$Options.focus_first()
