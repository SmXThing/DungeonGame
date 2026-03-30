extends Weapon
class_name Bow

var arrow_speed_scale: float
var shoot_speed_scale: float
var piercing: int

var projectile: PackedScene

func _ready() -> void:
	hide()

func shoot(dir: Vector2) -> void:
	var arrow: Projectile = projectile.instantiate()
	arrow.global_position = global_position
	arrow.speed = arrow.speed * arrow_speed_scale
	arrow.piercing = piercing
	arrow.direction = dir
	arrow.rotation = Vector2(1, 0).angle_to(dir)
	arrow.damage = damage
	get_tree().get_first_node_in_group("Floor").add_child(arrow)
