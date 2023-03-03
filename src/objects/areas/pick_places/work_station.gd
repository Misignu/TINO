extends "res://src/objects/areas/pick_place.gd"

var is_working: bool = false

onready var texture_progress: TextureProgress = $ProgressBar/TextureProgress
onready var bar_tween: Tween = $ProgressBar/Tween
onready var work_timer: Timer = $WorkTimer

func _ready():
	
	if rotation_degrees >= 90:
		
		texture_progress.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT

# @main
func _start_working(initial_time: float, final_time: float, duration: float) -> void:
	var catch: bool

	texture_progress.max_value = final_time
	catch = (
		bar_tween.interpolate_property(texture_progress, "value", initial_time, final_time, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) and
		bar_tween.start()
	)
	assert(catch)
	texture_progress.visible = true
	work_timer.start(duration)
	is_working = true

func _stop_working():
	var catch: bool = bar_tween.stop(texture_progress, "value")
	
	assert(catch)
	texture_progress.visible = false
	work_timer.stop()
	is_working = false
