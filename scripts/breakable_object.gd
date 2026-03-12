extends CharacterBody2D
class_name BreakableObject

@export var particles: Node2D
@export var collision: CollisionShape2D
@export var hitbox: Area2D
@export var sprite: Sprite2D
@export var sfx: Node2D
@export var deletion_timer: Timer

func _ready() -> void:
	pass

func break_object() -> void:
	sfx.get_children()[randi_range(0, len(sfx.get_children()) - 1)].play()
	if hitbox:
		hitbox.queue_free()
	if collision:
		collision.queue_free()
	if len(particles.get_children()) > 0:
		for node in particles.get_children():
			if node is GPUParticles2D:
				node.emitting = true
	sprite.hide()

func _on_hitbox_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerAttack"):
		break_object()

func _on_delete_timeout() -> void:
	queue_free()
