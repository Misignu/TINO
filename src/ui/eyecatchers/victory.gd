extends ColorRect

const NEXT_SCENE = "res://src/ui/eyecatchers/splash_screen.tscn"

func _on_Animation_animation_finished(_anim_name: String) -> void:
	var catch: int = get_tree().change_scene(NEXT_SCENE)
	
	assert(catch == OK)
