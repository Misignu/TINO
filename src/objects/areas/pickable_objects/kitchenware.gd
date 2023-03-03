extends PickableObject
"""
Kitchenwares são Pickable Objects que podem conter Ingredients que formam uma recipe
"""
var current_ingredients: PoolStringArray = []


func insert_ingredient(ingredient: Ingredient):
	
	$Recipe.add_child(ingredient)
	current_ingredients.append(ingredient.name)


func remove_ingridient() -> PickableObject:
	var ingredient = $Recipe.get_child(0)
	
	$Recipe.remove_child(ingredient)
	current_ingredients.remove(0)
	
	return ingredient


func get_recipe() -> Node2D:
	var recipe: Node2D
	
	if $Recipe.get_child_count() > 0:
		recipe = $Recipe.get_child(0)
	
	return recipe
