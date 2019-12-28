extends Control
"""
Qualquer nó em que esta cena esteja anexada será interrompida sempre que scape for pressionado
"""
const ANIM_NAME = "blur_in"
onready var confirmation_dialog: ConfirmationDialog = $CanvasLayer/ConfirmationDialog

func _input(event):
	
	if event.is_action_pressed("escape"):
		
		get_parent().pause_mode = Node.PAUSE_MODE_STOP
		confirmation_dialog.visible = !get_tree().paused

# @signals
func _on_ConfirmationDialog_confirmed():
	get_tree().quit()

func _on_ConfirmationDialog_visibility_changed():
	var is_visible: bool = confirmation_dialog.visible
	
	get_tree().paused = is_visible
	
	if is_visible:
		
		$AnimationPlayer.play(ANIM_NAME)
		confirmation_dialog.get_child(2).get_child(3).grab_focus() # REFACTOR -> Verificar se não existe um comando para isso
		
	else:
		$AnimationPlayer.play_backwards(ANIM_NAME)

