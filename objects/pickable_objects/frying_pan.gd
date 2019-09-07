extends "res://objects/pickable_objects/kitchenware.gd"

func _on_fry_finished(timer: Timer):
	
	$Sprite/IngredientSprite.frame = 2
	timer.disconnect("timeout", self, "_on_fry_finished")

# @main
func insert_ingredient(ingredient: Ingredient) -> bool:
	var can_insert: bool = ._insert_ingredient(ingredient, ingredient.preparation_state == Ingredient.FRIABLE)
	
	if can_insert and current_ingredient.fried_frames != null:
		
		$Sprite/IngredientSprite.texture = current_ingredient.fried_frames
		
	else:
		
		push_warning(str("None fried_frames's texture defined to the Ingredient: ", current_ingredient.name))
	
	return can_insert

func fry_ingridient(timer: Timer) -> bool:
	var can_fry = false
	
	if current_ingredient != null and current_ingredient.preparation_state == Ingredient.FRIABLE:
		
		assert(timer.connect("timeout", self, "_on_fry_finished", [timer]) == OK)
		current_ingredient.prepare("fry", timer)
		
		can_fry = true
	
	return can_fry

func stop(timer: Timer):
	
	current_ingredient.stop("fry", timer)
