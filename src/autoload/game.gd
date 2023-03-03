tool
extends "res://src/autoload/ui.gd".UI

# Singleton that deals with this Game General data and behaviors

signal coins_changed

enum IngredientsIds {
	BREAD = 0,
	MEAT = 1,
	LETTUCE = 2
}

const ingredients = {
	IngredientsIds.BREAD: "res://src/objects/areas/pickable_objects/ingredients/bread.tscn",
	IngredientsIds.MEAT: "res://src/objects/areas/pickable_objects/ingredients/meat.tscn",
	IngredientsIds.LETTUCE: "res://src/objects/areas/pickable_objects/ingredients/lettuce.tscn"
}

var coins: int = 50 setget set_coins
var players := [
	Player.new(),
	Player.new(),
	Player.new(),
	Player.new()
] setget set_players


func has_players_selected() -> bool:
	var value := false
	
	for player in players:
		
		if player.is_device_atached():
			
			value = true
			break
	
	return value


func is_player_atached_to_device(index: int) -> int:
	var player_index: int = -1
	
	for i in range(players.size()):
		
		if players[i].device == index:
			
			player_index = i
			break
	
	return player_index


func get_availlable_player_index() -> int:
	var value: int
	
	for i in range(players.size()):
		
		if not players[i].is_device_atached():
			
			value = i
			break
	
	return value


func get_igredient_data(ingredients_id: int) -> String:
	return ingredients[ingredients_id]


func set_players(new_array: Array):
	
	var player: Player
	
	for i in new_array.size(): # Re-organize the array based in if a device is atached
		player = new_array[i]
		
		if not player.is_device_atached():
		
			new_array.remove(i)
			new_array.push_back(player)
#
#	for player in new_array:
#		print("Player id: ", player.id)
	
	players = new_array


func set_coins(value: int) -> void:
	var catch: int
	
	if value <= 0:
		
		catch = get_tree().change_scene("res://src/ui/eyecatchers/game_over.tscn")
		assert(catch == OK)
	
	emit_signal("coins_changed", value, value < coins)
	coins = value


class Player:
	
	var id: int = -1 setget set_id
	var device: int = 0
	var character: StreamTexture
	
	func clear():
		
		device = 0
		id = -1
		character = null
	
	
	func is_device_atached() -> bool:
		return device != 0
	
	
	func set_id(value):
		
		if value < 0:
			clear()
		
		id = value
