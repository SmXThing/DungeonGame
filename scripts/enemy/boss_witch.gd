extends CharacterBody2D

signal boss_defeated
signal phase_changed(new_phase: int)

@export var max_health: int = 300
@export var move_speed: float = 95.0
@export var preferred_distance: float = 230.0
@export var too_close_distance: float = 130.0
@export var too_far_distance: float = 320.0
@export var strafe_strength: float = 0.9
@export var direction_change_time_min: float = 1.0
@export var direction_change_time_max: float = 2.2

@export var regular_attack_cooldown: float = 1.35
@export var rapid_fire_cooldown: float = 5.5
@export var rapid_fire_shots: int = 6
@export var rapid_fire_delay: float = 0.16

@export var projectile_spawn_offset: float = 18.0

@export var projectile_scene_1: PackedScene
@export var projectile_scene_2: PackedScene
@export var projectile_scene_3: PackedScene

@export var player_path: NodePath

@onready var attack_point: Marker2D = $AttackPoint
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var phase_label: Label = get_node_or_null("PhaseLabel")

var health: int
var phase: int = 1

var player: Node2D = null
var strafe_dir: int = 1
var move_change_timer: float = 0.0
var attack_timer: float = 0.0
var rapid_timer: float = 0.0

var is_rapid_firing: bool = false
var rapid_shots_left: int = 0
var rapid_shot_timer: float = 0.0

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	health = max_health

	if player_path != NodePath():
		player = get_node_or_null(player_path)

	move_change_timer = rng.randf_range(direction_change_time_min, direction_change_time_max)
	attack_timer = regular_attack_cooldown * 0.75
	rapid_timer = rapid_fire_cooldown

	if hurtbox.has_signal("area_entered"):
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)

	_update_phase_label()

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if health <= max_health / 2 and phase == 1:
		_enter_phase_2()

	var to_player := player.global_position - global_position
	var distance := to_player.length()
	var dir_to_player := to_player.normalized()

	_face_player(dir_to_player)
	_handle_movement(delta, dir_to_player, distance)
	_handle_attacks(delta, dir_to_player, distance)

	move_and_slide()

func _handle_movement(delta: float, dir_to_player: Vector2, distance: float) -> void:
	move_change_timer -= delta
	if move_change_timer <= 0.0:
		move_change_timer = rng.randf_range(direction_change_time_min, direction_change_time_max)
		if rng.randf() < 0.65:
			strafe_dir *= -1

	var perpendicular := Vector2(-dir_to_player.y, dir_to_player.x) * strafe_dir
	var desired_velocity := Vector2.ZERO

	# Smart but readable movement:
	# - backs off if player gets too close
	# - approaches if player is too far
	# - mostly circles at preferred range
	if distance < too_close_distance:
		desired_velocity = (-dir_to_player + perpendicular * 0.45).normalized() * move_speed
	elif distance > too_far_distance:
		desired_velocity = (dir_to_player + perpendicular * 0.35).normalized() * move_speed
	else:
		desired_velocity = perpendicular.normalized() * move_speed * strafe_strength

	# Small hesitation during rapid fire so player can read the attack
	if is_rapid_firing:
		desired_velocity *= 0.35

	velocity = desired_velocity

func _handle_attacks(delta: float, dir_to_player: Vector2, distance: float) -> void:
	attack_timer -= delta
	rapid_timer -= delta

	if is_rapid_firing:
		rapid_shot_timer -= delta
		if rapid_shots_left > 0 and rapid_shot_timer <= 0.0:
			rapid_shot_timer = rapid_fire_delay
			rapid_shots_left -= 1
			_fire_random_projectile(dir_to_player, true)
		elif rapid_shots_left <= 0:
			is_rapid_firing = false
		return

	# Rapid fire only exists in phase 2
	if phase == 2 and rapid_timer <= 0.0 and distance <= too_far_distance + 60.0:
		_start_rapid_fire()
		rapid_timer = rapid_fire_cooldown
		return

	# Regular paced attack
	if attack_timer <= 0.0:
		_fire_random_projectile(dir_to_player, false)
		attack_timer = regular_attack_cooldown

func _start_rapid_fire() -> void:
	is_rapid_firing = true
	rapid_shots_left = rapid_fire_shots
	rapid_shot_timer = 0.0

	if animated_sprite and animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("cast"):
		animated_sprite.play("cast")

func _fire_random_projectile(dir_to_player: Vector2, is_rapid: bool) -> void:
	var projectile_scene := _pick_random_projectile_scene()
	if projectile_scene == null:
		return

	var projectile = projectile_scene.instantiate()
	if projectile == null:
		return

	var spawn_pos := attack_point.global_position
	if attack_point == null:
		spawn_pos = global_position + dir_to_player * projectile_spawn_offset

	projectile.global_position = spawn_pos

	# Tiny spread during rapid fire so it looks more chaotic but still fair
	var spread := 0.0
	if is_rapid:
		spread = deg_to_rad(rng.randf_range(-8.0, 8.0))
	else:
		spread = deg_to_rad(rng.randf_range(-3.0, 3.0))

	var final_dir := dir_to_player.rotated(spread).normalized()

	# Pass projectile data into projectile script
	if projectile.has_method("setup"):
		var damage := 12
		var speed := 220.0

		if is_rapid:
			damage = 8
			speed = 250.0
		else:
			damage = rng.randi_range(11, 15)
			speed = rng.randf_range(210.0, 245.0)

		projectile.setup(final_dir, speed, damage, self)

	get_tree().current_scene.add_child(projectile)

	if animated_sprite and animated_sprite.sprite_frames:
		if animated_sprite.sprite_frames.has_animation("cast"):
			animated_sprite.play("cast")

func _pick_random_projectile_scene() -> PackedScene:
	var options: Array[PackedScene] = []

	if projectile_scene_1 != null:
		options.append(projectile_scene_1)
	if projectile_scene_2 != null:
		options.append(projectile_scene_2)
	if projectile_scene_3 != null:
		options.append(projectile_scene_3)

	if options.is_empty():
		return null

	return options[rng.randi_range(0, options.size() - 1)]

func take_damage(amount: int) -> void:
	if amount <= 0:
		return

	health -= amount
	health = max(health, 0)

	if animated_sprite and animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("hurt"):
		animated_sprite.play("hurt")

	if health <= 0:
		_die()
		return

	if health <= max_health / 2 and phase == 1:
		_enter_phase_2()

func _enter_phase_2() -> void:
	phase = 2
	move_speed += 18.0
	regular_attack_cooldown = 1.0
	emit_signal("phase_changed", phase)
	_update_phase_label()

	# Immediate pressure when phase 2 starts
	rapid_timer = 1.2

func _die() -> void:
	emit_signal("boss_defeated")
	queue_free()

func _face_player(dir_to_player: Vector2) -> void:
	if animated_sprite == null:
		return

	if abs(dir_to_player.x) > 0.05:
		animated_sprite.flip_h = dir_to_player.x < 0

func _update_phase_label() -> void:
	if phase_label:
		phase_label.text = "Phase %d | HP: %d / %d" % [phase, health, max_health]

func _on_hurtbox_area_entered(area: Area2D) -> void:
	# Example: player's sword/hitbox/projectile should be in group "player_attack"
	# and optionally have a damage variable.
	if not area.is_in_group("player_attack"):
		return

	var damage := 10
	if "damage" in area:
		damage = area.damage

	take_damage(damage)
