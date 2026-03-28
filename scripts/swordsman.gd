extends Player
class_name Melee

func _ready() -> void:
	'''var default_weapon: Sword = weapons.compile_weapon("sword", weapons.default_weapons[0], "Common")
	equipped = default_weapon'''
	var default_weapon: Sword = weapons.generate_random_weapon("sword")
	inventory.append(default_weapon)
	equipped = default_weapon
	equipped.global_position = sword_marker.global_position
	arm.add_child(equipped)

func swing_sword() -> void:
	is_attacking = true
	arm.rotation = -(PI - atan2(5, 3))
	equipped.trigger()
	
	var tween = create_tween()
	tween.tween_property(arm, "rotation", atan2(3, 5), 0.25 / equipped.attack_speed_scale)
	
	await get_tree().create_timer(0.25 / equipped.attack_speed_scale).timeout
	equipped.disable()
	is_attacking = false
