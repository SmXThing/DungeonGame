extends Node
class_name State

##States that can be activated from root state
@export var connected_states: Array[Node] = []
##Animation(s) that is/are tied to this state
@export var animations: Array[String] = []
var active: bool = false

func trigger() -> void:
	active = true

func exit_state() -> void:
	active = false
