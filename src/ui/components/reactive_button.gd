extends ToolButton

const ANIM = {
	SELECTED = "rainbow",
	DESELECTED = "idle"
}
onready var player: AnimationPlayer = $AnimationPlayer

func _on_ReactiveButton_focus_entered():
	
	player.play(ANIM.SELECTED)
	$SelectSFX.play()

func _on_ReactiveButton_focus_exited():
	player.play(ANIM.DESELECTED)

func _on_ReactiveButton_mouse_entered():
	grab_focus()
