extends Equipment
class_name Armor

@export var defense: int

func get_defense() -> int:
	return defense

func get_info() -> Array:
	var info: Array = []
	
	info.append(item_name)
	info.append(item_description)
	info.append(sprite)
	info.append(rarity)
	info.append(defense)
	return info
