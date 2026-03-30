extends Player
class_name Ranger

@onready var arm: Node2D = $Arm
@onready var bow_marker: Marker2D = $Arm/BowMarker

func _ready() -> void:
	arm.hide()
	
	var default_weapon: Bow = weapons.compile_weapon("bow", weapons.default_weapons[1], "Common")
	equipped = default_weapon
	inventory.append(default_weapon)
	equipped.global_position = bow_marker.global_position
	arm.add_child(equipped)

func shoot(direction: Vector2) -> void:
	is_attacking = true

	if direction.x < 0:
		arm.scale.x = -1
	else:
		arm.scale.x = 1
	
	equipped.trigger()
	equipped.shoot(direction)
	
	await get_tree().create_timer(0.5 / equipped.shoot_speed_scale).timeout
	arm.hide()
	equipped.disable()
	is_attacking = false
