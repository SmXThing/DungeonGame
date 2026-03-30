# enemy.gd
extends CharacterBody2D

# class name
class_name Enemy

# four possible states the enemy can be in 
enum State { IDLE, PATROL, CHASE, ATTACK }

# variables that can be changed in inspector
@export var speed: float = 80.0
@export var health: int = 50
@export var damage: int = 10
@export var attack_range: float = 20.0
@export var detection_range: float = 150.0
@export var attack_cooldown: float = 1.0

# variables that store values for enemy timer
@export var min_stop_time: float = 0.5
@export var max_stop_time: float = 2.0
@export var min_move_time: float = 1.0
@export var max_move_time: float = 3.0

@export var sprite: Sprite2D

# variables 
var state = State.PATROL
var player: Player = null
var patrol_direction = Vector2(1, 0)
var attack_timer: float = 0.0
var patrol_timer: float = 1.0
var is_patrol_moving: bool = true
var wall_stop_timer: float = 0.0

# reference to the RayCast2D child node
@onready var ray: RayCast2D = $RayCast
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	health_bar.max_value = health
	health_bar.value = health

func _physics_process(delta: float) -> void:
	attack_timer -= delta
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	# basically an if/else statement
	match state:
		State.IDLE:   idle_state()
		State.PATROL: patrol_state()
		State.CHASE:  chase_state()
		State.ATTACK: attack_state()

	move_and_slide()

# checks if a wall is blocking line of sight to the player
func can_see_player() -> bool:
	if player == null:
		return false
	# point the ray toward the player using local coordinates
	ray.target_position = to_local(player.global_position)
	ray.force_raycast_update()
	# if the ray hits something, a wall is blocking the view
	return not ray.is_colliding()

# state functions
func idle_state() -> void:
	velocity = Vector2.ZERO

# patrol state
func patrol_state() -> void:
	patrol_timer -= get_physics_process_delta_time()

	# switch between moving and stopping
	if patrol_timer <= 0.0:
		is_patrol_moving = not is_patrol_moving
		if is_patrol_moving:
			patrol_timer = randf_range(min_move_time, max_move_time)
			patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		else:
			patrol_timer = randf_range(min_stop_time, max_stop_time)

	# if recently paused due to wall, count down
	if wall_stop_timer > 0.0:
		wall_stop_timer -= get_physics_process_delta_time()
		velocity = Vector2.ZERO

	elif is_patrol_moving:
		# point the RayCast in the patrol direction
		ray.target_position = patrol_direction * 0.5  # adjust
		ray.force_raycast_update()

		# if ray sees a wall ahead, pick a new direction
		if ray.is_colliding():
			wall_stop_timer = 0.4
			velocity = Vector2.ZERO

			# pick a new random direction
			patrol_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

		# move in patrol direction
		else:
			velocity = patrol_direction * speed

	else:
		velocity = Vector2.ZERO

	# detect player
	if player != null and global_position.distance_to(player.global_position) < detection_range and can_see_player():
		state = State.CHASE

# chase state
func chase_state() -> void:
	if player == null:
		return
	# if player ducked behind a wall, give up and patrol
	if not can_see_player():
		state = State.PATROL
		return
	var distance = global_position.distance_to(player.global_position)
	velocity.x = move_toward(velocity.x, ((player.global_position - global_position).normalized() * speed).x, speed / 8)
	velocity.y = move_toward(velocity.y, ((player.global_position - global_position).normalized() * speed).y, speed / 8)
	if distance < attack_range:
		state = State.ATTACK
	elif distance > detection_range:
		state = State.PATROL

# attack state
func attack_state() -> void:
	# stops movement to attack
	velocity = Vector2.ZERO
	if player == null:
		return
	var distance = global_position.distance_to(player.global_position)
	if distance > attack_range:
		state = State.CHASE
		return
	if attack_timer <= 0.0 && health_bar.value > 0:
		player.take_damage(damage)
		attack_timer = attack_cooldown

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerAttack"):
		take_damage(area.get_parent().damage + player.strength)

func take_damage(amount: int) -> void:
	health_bar.value -= amount
	if health_bar.value <= 0:
		sprite.hide()
		health_bar.hide()
		if $HitboxArea:
			$HitboxArea.queue_free()
		set_collision_layer_value(3, false)
		die()
	else:
		knockback()

func knockback() -> void:
	velocity = -velocity

func die() -> void:
	$Blood.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
