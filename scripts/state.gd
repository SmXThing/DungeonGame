extends Node
class_name State

signal transitioned
@export var body: AnimatedSprite2D
@export var legs: AnimatedSprite2D
@export var arms: AnimatedSprite2D
@export var machine: Node
@export var player: Player

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func emit(new_state: String) -> void:
	transitioned.emit(self, new_state)
