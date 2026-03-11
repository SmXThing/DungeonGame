# enemy.gd
extends CharacterBody2D

# four possible states the enemy can be in 
enum State { IDLE, PATROL, CHASE, ATTACK }

# variables that can be changed in inspector
@export var speed: float = 80.0
@export var health: int = 50
@export var damage: int = 10
@export var attack_range: float = 20.0
@export var detection_range: float = 150.0
@export var attack_cooldown: float = 1.0

# variables 
var state = State.PATROL
var player: Player = null
var patrol_direction = Vector2(1, 0)
var attack_timer: float = 0.0

func _ready() -> void:
	# Uses your Player class_name — no group needed
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	attack_timer -= delta
	
	# basically an if/else statement
	match state:
		State.IDLE:   idle_state()
		State.PATROL: patrol_state()
		State.CHASE:  chase_state()
		State.ATTACK: attack_state()

	move_and_slide()

# state functions
func idle_state() -> void:
	velocity = Vector2.ZERO
# patrol state
func patrol_state() -> void:
	velocity = patrol_direction * speed
	if is_on_wall():
		patrol_direction.x *= -1
	# also check for floor/ceiling collisions in top-down
	if get_slide_collision_count() > 0:
		patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if player == null:
		return
	if global_position.distance_to(player.global_position) < detection_range:
		state = State.CHASE
# chase state
func chase_state() -> void:
	if player == null:
		return
	var distance = global_position.distance_to(player.global_position)
	velocity = (player.global_position - global_position).normalized() * speed
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
	if attack_timer <= 0.0:
		player.take_damage(damage)
		attack_timer = attack_cooldown

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
