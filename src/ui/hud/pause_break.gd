extends Control
"""
Qualquer nó em que esta cena esteja anexada será interrompida sempre que scape for pressionado
"""
signal popup_overlay_hidded

const ANIM_NAME = "blur_in"
onready var confirmation_dialog: ConfirmationDialog = $CanvasLayer/ConfirmationDialog


func _ready() -> void:
	
	Game.connect("ui_theme_toggled", self, "_on_Game_ui_theme_toggled")
	
	if Game.is_light_mode_on:
		$CanvasLayer/ConfirmationDialog.theme = Game.LIGHT_THEME


func _on_Game_ui_theme_toggled(new_theme: Theme) -> void:
	$CanvasLayer/ConfirmationDialog.theme = new_theme


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
		confirmation_dialog.get_cancel().grab_focus()
		
	else:
		$AnimationPlayer.play_backwards(ANIM_NAME)
		emit_signal("popup_overlay_hidded")
