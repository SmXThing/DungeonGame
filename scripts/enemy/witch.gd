extends CharacterBody2D

@export var max_health: int = 35
@export var move_speed: float = 60.0
@export var preferred_distance: float = 170.0
@export var too_close_distance: float = 90.0
@export var too_far_distance: float = 240.0
@export var attack_cooldown_time: float = 1.8

@export var fire_projectile_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_point: Marker2D = $AttackPoint
@onready var attack_cooldown: Timer = $AttackCooldown

var health: int
var player: Node2D = null
var can_attack: bool = true
var strafe_dir: int = 1
var strafe_timer: float = 0.0
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	health = max_health
	player = get_tree().get_first_node_in_group("player") as Node2D

	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)

	strafe_timer = rng.randf_range(0.8, 1.5)

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()
	var dir := to_player.normalized()

	_face_player(dir)

	strafe_timer -= delta
	if strafe_timer <= 0.0:
		strafe_timer = rng.randf_range(0.8, 1.5)
		if rng.randf() < 0.6:
			strafe_dir *= -1

	var side := Vector2(-dir.y, dir.x) * strafe_dir

	if distance < too_close_distance:
		velocity = (-dir + side * 0.4).normalized() * move_speed
		_play_walk()
	elif distance > too_far_distance:
		velocity = (dir + side * 0.2).normalized() * move_speed
		_play_walk()
	else:
		velocity = side.normalized() * move_speed * 0.7
		_play_walk()

	if can_attack and distance <= too_far_distance:
		_fire_projectile(dir)

	move_and_slide()

func _fire_projectile(dir: Vector2) -> void:
	if fire_projectile_scene == null:
		return

	can_attack = false
	attack_cooldown.wait_time = attack_cooldown_time
	attack_cooldown.start()

	var projectile = fire_projectile_scene.instantiate()
	projectile.global_position = attack_point.global_position

	if projectile.has_method("setup"):
		projectile.setup(dir, 220.0, 10, self)

	get_tree().current_scene.add_child(projectile)

	if sprite.sprite_frames and sprite.sprite_frames.has_animation("attack"):
		sprite.play("attack")

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)

	if sprite.sprite_frames and sprite.sprite_frames.has_animation("hurt"):
		sprite.play("hurt")

	if health <= 0:
		queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player_attack"):
		return

	var damage := 10
	if "damage" in area:
		damage = area.damage

	take_damage(damage)

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _face_player(dir: Vector2) -> void:
	if abs(dir.x) > 0.05:
		sprite.flip_h = dir.x < 0

func _play_walk() -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
		if sprite.animation != "walk":
			sprite.play("walk")
