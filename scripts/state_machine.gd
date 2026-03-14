extends Node

@export var player: CharacterBody2D
@export var sprites: AnimatedSprite2D
@export var idle_animation: String
@export var walking_animation: String
@export var attacking_animation: String
@export var special_animation: String

@onready var idle: State = $idle
@onready var walking: State = $walking
@onready var attacking: State = $attacking
@onready var special: State = $special

func _ready() -> void:
	idle.trigger()
