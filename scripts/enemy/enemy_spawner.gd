extends Node2D

@export var enemy_scene: PackedScene
@export var respawn_time: float = 5.0

@onready var respawn_timer: Timer = $RespawnTimer

var current_enemy: Node = null

func _ready() -> void:
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)
	spawn_enemy()

func spawn_enemy() -> void:
	if enemy_scene == null:
		return

	current_enemy = enemy_scene.instantiate()
	current_enemy.global_position = global_position
	get_tree().current_scene.add_child(current_enemy)

	if current_enemy.has_signal("tree_exited"):
		current_enemy.tree_exited.connect(_on_enemy_removed)

func _on_enemy_removed() -> void:
	respawn_timer.wait_time = respawn_time
	respawn_timer.start()

func _on_respawn_timer_timeout() -> void:
	if current_enemy == null or not is_instance_valid(current_enemy):
		spawn_enemy()
