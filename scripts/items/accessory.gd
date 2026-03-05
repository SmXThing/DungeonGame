extends Equipment
class_name Accessory

@export var stats: Array[String]
@export var modifier: int

func get_stat() -> Array[String]:
	return stats

func get_modifier() -> int:
	return modifier

func get_info() -> Array:
	var info: Array = []
	
	info.append(item_name)
	info.append(item_description)
	info.append(sprite)
	info.append(rarity)
	info.append(stats)
	info.append(modifier)
	return info
