extends Node2D

@export var projectile_scene: PackedScene
@export var fire_cooldown: float = 0.35
@export var arrow_speed: float = 400.0
@export var arrow_damage: int = 10

var _cooldown: float = 0.0

func _process(delta: float) -> void:
	_cooldown -= delta
	
	if Input.is_action_just_pressed("shoot") and _cooldown <= 0.0:
		_shoot()

func _shoot() -> void:
	# scence needs to be assigned
	if projectile_scene == null:
		push_warning("Bow: projectile_scene not set!")
		return
	# reset cooldown to revent player spamming shots
	_cooldown = fire_cooldown

	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	# here I am assuming that bow will be a child of player
	var player = get_parent()
	projectile.global_position = player.global_position

	var direction = (player.get_global_mouse_position() - player.global_position).normalized()
	projectile.setup(direction, arrow_speed, arrow_damage, player)
