extends Particles2D
"""
Esse Particles2D é um módulo que dá a capacidade objetos serem incendiados.
"""
signal fire_started
signal fire_finished

const BANISH_FIRE_TIME = 3

var is_firing: bool setget set_is_firing
var fire_intensity: float = 1.0

onready var fire_max_scale: float = process_material.scale
onready var fire_area: Area2D = $Area2D
onready var tween: Tween = $Tween
onready var timer: Timer = $Timer
onready var fire_bsfx: AudioStreamPlayer2D = $FireBSFX2D

func _ready() -> void:
	process_material = process_material.duplicate(true) # REFACTOR -> Optimazation

# @signals
func _on_FireExtintor_extintor_started() -> void: # REFACTOR -> Optimization
	var duration: float = BANISH_FIRE_TIME * fire_intensity
	var catch: bool
	
	catch = (
		tween.stop(self, "process_material:scale") and
		tween.interpolate_property(self, "fire_intensity", fire_intensity, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) and
		tween.interpolate_property(self, "process_material:scale", process_material.scale, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) and
		tween.start()
	)
	assert(catch)

func _on_FireExtintor_extintor_finished() -> void: # REFACTOR -> Optimization
	var duration: float = BANISH_FIRE_TIME * (1.0 - fire_intensity)
	var catch: int
	
	catch = (
		tween.stop(self, "fire_intensity") and
		tween.stop(self, "process_material:scale") and
		tween.interpolate_property(self, "fire_intensity", fire_intensity, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) and
		tween.interpolate_property(self, "process_material:scale", process_material.scale, fire_max_scale, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	)
	assert(catch)

func _on_Area2D_area_entered(area: Area2D) -> void:
	
	if area.get_parent().has_method("set_is_firing"):
		area.get_parent().set_is_firing(true)

func _on_Tween_tween_completed(object, key: String) -> void:
	
	if object == self and key == ":fire_intensity" and fire_intensity == 0:
		set_is_firing(false)

func _on_Timer_timeout() -> void:
	fire_area.monitoring = true

# @setters
func set_is_firing(value := true) -> void:
	
	if value:
		
		timer.start()
		fire_bsfx.play()
		emit_signal("fire_started")
		
	else:
		timer.stop()
		fire_area.monitoring = false
		fire_bsfx.stop()
		emit_signal("fire_finished")
	
	emitting = value
	is_firing = value
