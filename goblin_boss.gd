extends CharacterBody2D

signal boss_defeated

@export var max_health: int = 220
@export var move_speed: float = 95.0
@export var chase_range: float = 260.0
@export var attack_range: float = 42.0
@export var circle_range: float = 80.0

@export var punch_damage: int = 16
@export var scratch_damage: int = 12

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_area: Area2D = $AttackArea
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

	strafe_timer = rng.randf_range(0.8, 1.6)

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()
	var dir := to_player.normalized()

	_face_player(dir)

	if distance > chase_range:
		velocity = Vector2.ZERO
		_play_idle()
	elif distance > attack_range:
		# Chase, but with a little side movement so he feels alive
		strafe_timer -= delta
		if strafe_timer <= 0.0:
			strafe_timer = rng.randf_range(0.8, 1.6)
			if rng.randf() < 0.6:
				strafe_dir *= -1

		var side := Vector2(-dir.y, dir.x) * strafe_dir * 0.35
		velocity = (dir + side).normalized() * move_speed
		_play_walk()
	else:
		# Stay active in close range instead of freezing
		strafe_timer -= delta
		if strafe_timer <= 0.0:
			strafe_timer = rng.randf_range(0.5, 1.2)
			strafe_dir *= -1

		var side_close := Vector2(-dir.y, dir.x) * strafe_dir
		velocity = side_close.normalized() * move_speed * 0.55
		_play_walk()

		if can_attack:
			_do_melee_attack()

	move_and_slide()

func _do_melee_attack() -> void:
	can_attack = false
	attack_cooldown.wait_time = rng.randf_range(0.9, 1.3)
	attack_cooldown.start()

	var attack_type := "punch"
	if rng.randf() < 0.45:
		attack_type = "scratch"

	var damage := punch_damage
	if attack_type == "scratch":
		damage = scratch_damage

	if sprite.sprite_frames and sprite.sprite_frames.has_animation(attack_type):
		sprite.play(attack_type)

	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player") and body.has_method("take_damage"):
			body.take_damage(damage)

func take_damage(amount: int) -> void:
	if amount <= 0:
		return

	health -= amount
	health = max(health, 0)

	if sprite.sprite_frames and sprite.sprite_frames.has_animation("hurt"):
		sprite.play("hurt")

	if health <= 0:
		emit_signal("boss_defeated")
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

func _play_idle() -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
		if sprite.animation != "idle":
			sprite.play("idle")

func _play_walk() -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
		if sprite.animation != "walk":
			sprite.play("walk")
