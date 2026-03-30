extends Weapon
class_name Staff

var fire_speed_scale: float
var piercing: int
var AOE: bool
var focal_point: Vector2

var projectile: PackedScene

@onready var focal_marker: Marker2D = Marker2D.new()

func _ready() -> void:
	hide()
	add_child(focal_marker)
	focal_marker.position = focal_point

func fire(dir: Vector2) -> void:
	var bullet: Projectile = projectile.instantiate()
	bullet.global_position = focal_marker.global_position
	bullet.AOE = AOE
	bullet.piercing = piercing
	bullet.direction = dir
	bullet.rotation = Vector2(1, 0).angle_to(dir)
	get_tree().get_first_node_in_group("Floor").add_child(bullet)
