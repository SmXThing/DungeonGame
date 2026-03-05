extends Item
class_name Potion

signal duration_ended

@export var stat_boost: String
@export var modifier: int
@export var duration: float
@export var timer: Timer

func _ready() -> void:
	timer.wait_time = duration

func get_stat_boost() -> String:
	return stat_boost

func get_modifier() -> int:
	return modifier

func _on_timer_timeout() -> void:
	duration_ended.emit()

func get_info() -> Array:
	var info: Array = []
	
	info.append(item_name)
	info.append(item_description)
	info.append(sprite)
	info.append(stat_boost)
	info.append(modifier)
	info.append(duration)
	info.append(timer)
	return info
