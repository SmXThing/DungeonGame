extends Player
class_name Mage

@onready var staff_marker: Marker2D = $Arm/StaffMarker
@onready var arm: Node2D = $Arm

func _ready() -> void:
	arm.hide()
	
	var default_weapon: Staff = weapons.compile_weapon("staff", weapons.default_weapons[2], "Common")
	equipped = default_weapon
	inventory.append(default_weapon)
	
	equipped.global_position = staff_marker.global_position
	arm.add_child(equipped)

func fire(prj_direction: Vector2, plr_direction: Vector2) -> void:
	is_attacking = true
	equipped.trigger()
	
	if plr_direction.x < 0:
		arm.scale.x = -1
	else:
		arm.scale.x = 1
	
	equipped.fire(prj_direction)
	
	await get_tree().create_timer(0.5 / equipped.fire_speed_scale).timeout
	equipped.disable()
	arm.hide()
	is_attacking = false
