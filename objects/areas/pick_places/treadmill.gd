extends "res://objects/areas/pick_place.gd"

signal recipe_delived
signal plate_returned

export(float, 60) var return_time: float = 10
var cached_plates := Array()

onready var tween := $Tween
onready var deliver_sine_sfx := $DeliverSineSFX

func _on_plate_return_Timer_timeout(timer: Timer):
	
	emit_signal("plate_returned", cached_plates.back())
	cached_plates.pop_back()
	timer.disconnect("timeout", self, "_on_plate_return_Timer_timeout")
	timer.queue_free()

func _on_Tween_tween_completed(plate: PickableObject, _key): # TODO: Implement Individual timer
	
	current_object = null
	plate.current_recipe = null
	cached_plates.append(plate)
	_create_and_run_timer()

# @main
func insert_object(object: PickableObject) -> bool: # REFACTOR -> Código gambiarroso
	var can_insert = false
	
	if "Plate" in object.name:
		
		if object.current_recipe != null and object.is_clean:
			can_insert = .insert_object(object)
	
	if can_insert:
		_delivery_animation(object)
	
	return can_insert

func _delivery_animation(plate: PickableObject):
	
	tween.interpolate_property(plate, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	deliver_sine_sfx.play()
	tween.start()
	emit_signal("recipe_delived", plate.current_recipe)

func _create_and_run_timer():
	var timer := Timer.new()
	
	add_child(timer)
	assert(timer.connect("timeout", self, "_on_plate_return_Timer_timeout", [timer]) == OK)
	timer.start(return_time)
