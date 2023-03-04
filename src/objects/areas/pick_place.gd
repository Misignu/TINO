tool
extends Area2D
"""
PickPlace é uma Area2D que permite que objetos sejam inseridos na Position2D current_object.
"""
var is_burning: bool setget set_is_burning
onready var pos_current_object: Position2D = $CurrentObject
export var put_object: PackedScene


func _ready():
	
	if Engine.is_editor_hint():
		if put_object:
			var pickable_object := put_object.instance() as PickableObject
			
			if pickable_object == null:
				printerr("Error! Object is not pickable")
			else:
				add_child(pickable_object)
	else:
		# Inserir instância do objeto nessa área
		if put_object:
			var pickable_object := put_object.instance() as PickableObject
			assert(pickable_object != null, "Error! Object is not pickable")
# warning-ignore:return_value_discarded
			insert_object(pickable_object)


func _on_FireParticles_fire_finished() -> void:
	is_burning = false


func _on_FireParticles_fire_started() -> void:
	is_burning = true


# @main
func insert_object(object: PickableObject) -> bool:
	var was_inserted: bool
	
	if pos_current_object.get_child_count() == 0:
		
		pos_current_object.add_child(object.grab())
		was_inserted = true
		
	elif object is Ingredient and pos_current_object.get_child(0).has_method("insert_ingredient"):
		was_inserted = pos_current_object.get_child(0).insert_ingredient(object)
	
	return was_inserted


func provide_ingredient(ingredient: Ingredient) -> bool:
	"""
	Providencia um ingrediente para um objeto inserido na área.
	"""
	if pos_current_object.get_child_count() == 1:
		var object := pos_current_object.get_child(0) as PickableObject
		assert(object != null, "Error! Current putted object not pickable")
		
		if object.has_method("insert_ingredient"):
			return object.call("insert_ingredient", ingredient)
	
	return false


func remove_object() -> PickableObject:
	var object: PickableObject
	
	if not is_burning and pos_current_object.get_child_count() == 1:
		object = pos_current_object.get_child(0).grab()
	
	return object


# @setters
func set_is_burning(value: bool = true):
	$FireParticles.is_firing = value
