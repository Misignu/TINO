extends Node2D


const NONE = -1
const ARROW_MOVE_VELOCITY = .3
const LEVELS = PoolStringArray([
	"res://src/scenarios/level_x.tscn",
])

var has_target: bool
var next_place: int

onready var places: Array = ($Places as Node2D).get_children()
onready var last_place: int = places.size() - 1

onready var arrow: Node2D = $Arrow
onready var tween: Tween = $Tween


func _ready() -> void:
	arrow.position = places[0].position


func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_right"):
		
		_batch_selection(_pick_next(next_place, last_place))
		get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_left"):
		
		_batch_selection(_pick_previous(next_place, last_place))
		get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_accept"):
		
		if next_place != 0:
			return
		
		Game.change_scene("res://src/ui/menus/player_selection.tscn")


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	assert(object == arrow and key == ":global_position")
	
	select_next()


# Retorna o índice posterior, após atingir o último, retorna índice 0
func _pick_next(current: int, last: int) -> int:
	var next: int = current + 1
	
	if next > last:
		next = 0
	
	return next


# Retorna o índice anterior, ao atingir índice 0, retorna o último
func _pick_previous(current: int, last: int) -> int:
	var previous: int = current - 1
	
	if previous < 0:
		previous = last
	
	return previous


# Cache da seleção
func _batch_selection(to_select: int) -> void:
	next_place = to_select
	has_target = true
	
	if not tween.is_active():
		select_next()


# Seleciona o local determinado como `next`
func select_next() -> void:
	
	if not has_target:
		return
	
	if not(
			tween.interpolate_property(
				arrow, ":global_position", arrow.global_position, places[next_place].global_position,
				ARROW_MOVE_VELOCITY, Tween.TRANS_SINE
			) and tween.start()):
		push_error("Wouldn't able to animate property :global_position in %s." % arrow)
	
	has_target = false
