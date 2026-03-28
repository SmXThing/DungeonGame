extends Node2D
class_name Item

var item_name: String
var item_description: String
var sprite: Sprite2D

func get_item_name() -> String:
	return item_name

func get_desc() -> String:
	return item_description

func get_info() -> Array:
	var info: Array = []
	
	info.append(item_name)
	info.append(item_description)
	info.append(sprite)
	return info
