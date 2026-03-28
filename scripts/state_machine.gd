extends Node

@export var starting_state: State
@export var holder: Player

var active_state: State
var states: Dictionary[String, State] = {}

func _ready() -> void:
	for node in get_children():
		if node is State:
			states[node.name] = node
			node.transitioned.connect(_on_state_transitioned)
	
	if starting_state:
		starting_state.enter()
		active_state = starting_state

func _process(delta: float) -> void:
	if active_state:
		active_state.update(delta)

func _physics_process(delta: float) -> void:
	if active_state:
		active_state.physics_update(delta)

func _on_state_transitioned(state: State, new_state: String):
	if state != active_state:
		return
	
	var next_state: State = states[new_state.to_lower()]
	if !next_state:
		return
	
	if active_state:
		active_state.exit()
	
	next_state.enter()
	active_state = next_state

func get_last_direction() -> Vector2:
	return holder.facing

func get_holder() -> CharacterBody2D:
	return holder
