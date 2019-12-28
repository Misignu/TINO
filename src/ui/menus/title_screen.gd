extends CanvasLayer

const NEXT_SCENE = "res://src/ui/menus/player_selection.tscn"
const ANIM = "out"

onready var options: WindowDialog = $Options

func _ready():
	$MainMenu/VBoxContainer/MenuOptions/NewGame.grab_focus()

# @signals
func _on_NewGame_pressed():
	
	$MainMenu/Transition.play(ANIM)
	$Audio/Music.stop()
	OS.clipboard = "Obrigado por jogar!  " # WATCH -> HACKER DEMAIS

func _on_Continue_pressed():
	
	if OS.is_debug_build():
		
		print("Not implemented!\nThis is just for learning basic stuff folk XD")
		OS.window_minimized = true
	
	$Audio/NotImplementedSFX.play()

func _on_Options_pressed():
	
	options.popup()

func _on_Transition_animation_finished(anim_name: String):
	var catch: int
	
	if anim_name == ANIM:
		
#		Game.set_transparency_mode() # WATCH
		$VideoPlayer.stop()
		catch = get_tree().change_scene(NEXT_SCENE)
		assert(catch == OK)
