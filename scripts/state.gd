extends Node
class_name State

signal transitioned
@export var animation_sprite: AnimatedSprite2D
@export var machine: Node
@export var player: CharacterBody2D

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
