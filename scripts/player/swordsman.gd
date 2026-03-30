extends Player
class_name Melee

@onready var sword_marker: Marker2D = $ArmGroup/Arm/SwordMarker
@onready var arm_group: Node2D = $ArmGroup
@onready var arm: Node2D = $ArmGroup/Arm

func _ready() -> void:
	var default_weapon: Sword = weapons.compile_weapon("sword", weapons.default_weapons[0], "Common")
	inventory.append(default_weapon)
	equipped = default_weapon
	equipped.global_position = sword_marker.global_position
	arm.add_child(equipped)

func swing_sword() -> void:
	arm_sprites.speed_scale = equipped.attack_speed_scale
	
	if facing.x < 0:
		arm_group.scale.x = -1
	else:
		arm_group.scale.x = 1
	
	is_attacking = true
	arm.rotation = -(PI - atan2(5, 3))
	equipped.trigger()
	
	var tween = create_tween()
	tween.tween_property(arm, "rotation", atan2(3, 5), 0.25 / equipped.attack_speed_scale)
	
	await get_tree().create_timer(0.25 / equipped.attack_speed_scale).timeout
	arm_group.hide()
	equipped.disable()
	is_attacking = false
