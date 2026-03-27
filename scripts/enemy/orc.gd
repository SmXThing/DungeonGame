extends CharacterBody2D

@export var max_health: int = 45
@export var move_speed: float = 70.0
@export var chase_range: float = 220.0
@export var attack_range: float = 34.0
@export var attack_damage: int = 8

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_area: Area2D = $AttackArea
@onready var attack_cooldown: Timer = $AttackCooldown

var health: int
var player: Node2D = null
var can_attack: bool = true

func _ready() -> void:
	health = max_health
	player = get_tree().get_first_node_in_group("player") as Node2D

	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()
	var dir := to_player.normalized()

	_face_player(dir)

	if distance <= attack_range:
		velocity = Vector2.ZERO
		_play_idle()

		if can_attack:
			_attack()
	elif distance <= chase_range:
		velocity = dir * move_speed
		_play_walk()
	else:
		velocity = Vector2.ZERO
		_play_idle()

	move_and_slide()

func _attack() -> void:
	can_attack = false
	attack_cooldown.wait_time = 1.2
	attack_cooldown.start()

	if sprite.sprite_frames and sprite.sprite_frames.has_animation("attack"):
		sprite.play("attack")

	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player") and body.has_method("take_damage"):
			body.take_damage(attack_damage)

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

func _play_idle() -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
		if sprite.animation != "idle":
			sprite.play("idle")

func _play_walk() -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
		if sprite.animation != "walk":
			sprite.play("walk")
