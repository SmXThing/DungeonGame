extends Area2D

@export var speed: float = 250.0
@export var damage: int = 14
@export var life_time: float = 4.0

var direction: Vector2 = Vector2.RIGHT
var owner_node: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	life_time -= delta
	if life_time <= 0.0:
		queue_free()

func setup(new_direction: Vector2, new_speed: float, new_damage: int, new_owner: Node = null) -> void:
	direction = new_direction.normalized()
	speed = new_speed
	damage = new_damage
	owner_node = new_owner
	rotation = direction.angle()

func _on_body_entered(body: Node) -> void:
	if body == owner_node:
		return

	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_shield"):
		queue_free()
