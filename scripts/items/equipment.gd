extends Item
class_name Equipment

@export var rarity: String

func get_rarity() -> String:
	return rarity

func get_info() -> Array:
	var info: Array = []
	
	info.append(item_name)
	info.append(item_description)
	info.append(sprite)
	info.append(rarity)
	return info
