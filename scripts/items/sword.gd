extends Weapon
class_name Sword

var attack_speed_scale: float
var diagonal_range: int
var diagonal_width: int

@onready var hitbox_area: Area2D = Area2D.new()
@onready var hitbox: CollisionShape2D = CollisionShape2D.new()

func _ready() -> void:
	hide()
	
	sprite.rotation = PI/4
	
	hitbox_area.set_collision_layer_value(6, true)
	hitbox_area.add_to_group("PlayerAttack")
	hitbox_area.monitorable = false
	add_child(hitbox_area)
	
	hitbox.shape = RectangleShape2D.new()
	var actual_range: int = int(floor(diagonal_range * sqrt(2)))
	var actual_width: int = int(floor(diagonal_width * sqrt(2)))
	hitbox.shape.size = Vector2(actual_range, actual_width)
	hitbox.position.x = actual_range / 2.0
	hitbox_area.add_child(hitbox)	

func trigger() -> void:
	hitbox_area.monitorable = true
	show()

func disable() -> void:
	hitbox_area.monitorable = false
	hide()
