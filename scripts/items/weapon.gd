extends Equipment
class_name Weapon

var damage: int

func get_damage() -> int:
	return damage

func get_info() -> Array:
	var info: Array = []
	
	info.append(item_name)
	info.append(item_description)
	info.append(sprite)
	info.append(rarity)
	info.append(damage)
	return info
