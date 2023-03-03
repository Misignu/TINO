extends Area2D

class_name PickableObject, "res://assets/sprites/hud/drag.svg"


const PICK_PLACE_PATH = "res://src/objects/areas/pick_place.tscn"
export var use_pick_place: bool = false

onready var origin := get_parent() setget, get_origin
onready var collision_shape := $CollisionShape2D as CollisionShape2D
var is_grabbed: bool = false


func _ready() -> void:
	collision_shape.disabled = is_grabbed
	
	if use_pick_place:
		_add_pick_place()


func grab() -> PickableObject:
	is_grabbed = true
	
	if is_inside_tree():
		get_parent().remove_child(self)
		collision_shape.disabled = true
	
	position = Vector2.ZERO
	
	return self


func drop(pos: Vector2) -> void:
	is_grabbed = false
	
	origin.add_child(self)
	global_position = pos
	collision_shape.disabled = false


func _add_pick_place() -> void:
	
	var pick_place: Area2D = load(PICK_PLACE_PATH).instance() 
	
	pick_place.position = position
	get_parent().call_deferred("remove_child", self)
	origin.call_deferred("add_child", pick_place)
	pick_place.call_deferred("insert_object", self)


func get_origin() -> Node:
	return origin
