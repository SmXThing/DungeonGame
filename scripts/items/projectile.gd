extends CharacterBody2D
class_name Projectile

var speed: float = 250
var direction: Vector2
var piercing: int
var AOE: bool

@export var sprite: Sprite2D
@export var HitboxArea: Area2D
@export var hitbox: CollisionShape2D
@export var break_particles: Node2D
@export var trail_particles: Node2D
@export var crash_sfx: AudioStreamPlayer2D
@export var light: PointLight2D
var damage: int

func _ready() -> void:
	global_rotation = Vector2(0, 0).angle_to(direction)
	for node in trail_particles:
		if node is CPUParticles2D:
			node.emitting = true

func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if piercing > 0:
			piercing -= 1
		else:
			crash()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Wall"):
		crash()

func crash() -> void:
	if HitboxArea:
		HitboxArea.queue_free()
	if light:
		light.queue_free()
	speed = 0
	crash_sfx.play()
	sprite.hide()
	for node in break_particles.get_children():
		if node is GPUParticles2D:
			node.emitting = true
	
