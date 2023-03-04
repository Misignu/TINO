extends "res://src/objects/areas/pick_place.gd"

var cached_objects := Array()


# @signals
func _on_Treadmill_object_delivered(plate: PickableObject) -> void:
	_cache_object(plate)


func _on_Trash_object_delivered(object: PickableObject) -> void:
	_cache_object(object)


# @override
func remove_object() -> PickableObject:
	var object: PickableObject = .remove_object()
	
	if cached_objects:
# warning-ignore:return_value_discarded
		.insert_object(cached_objects.pop_front())
	
	return object


func insert_object(_object: PickableObject) -> bool:
	return false


# @main
func _cache_object(object: PickableObject) -> void:
	
	if not .insert_object(object):
		cached_objects.append(object)
