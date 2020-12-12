extends ColorRect


func _ready():
	get_tree().paused = true


func _on_AnimationPlayer_animation_finished(anim_name: String):
	
	if anim_name == "show":
		get_tree().paused = false
