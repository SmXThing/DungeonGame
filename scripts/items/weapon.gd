extends Equipment
class_name Weapon

@export var damage: int
@export var hitbox: Area2D

func get_damage() -> int:
	return damage

func get_info() -> Array:
	var info: Array = []
	
	info.append(item_name)
	info.append(item_description)
	info.append(sprite)
	info.append(rarity)
	info.append(damage)
	info.append(hitbox)
	return info
