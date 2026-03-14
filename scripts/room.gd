extends Node2D
class_name Room

var sensors: Array[Area2D]

var cell: Vector2i
var connected_cells: Array[Vector2i]
var has_chest: bool
var chest_opened: bool
var scene_path: String

func _ready() -> void:
	for node in $DirectionSensors.get_children():
		sensors.append(node)

func get_cell_pos() -> Vector2i:
	return cell

func get_scene_path() -> String:
	return scene_path

func _on_detection_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var index: int = 0
		var sensor_activated: bool
		for node in sensors:
			if node.has_overlapping_areas():
				load_adjacent_rooms(cell + globals.directions[index])
				sensor_activated = true
				break
			else:
				index += 1
		
		if !sensor_activated:
			load_adjacent_rooms(cell)

func _on_detection_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var index: int = 0
		for node in sensors:
			if node.has_overlapping_areas():
				unload_adjacent_rooms(cell + globals.directions[index])
				break
			else:
				index += 1

func load_adjacent_rooms(ignore: Vector2i) -> void:
	for room in connected_cells:
		if room != ignore:
			get_parent().load_room(room)

func unload_adjacent_rooms(ignore: Vector2i) -> void:
	for room in connected_cells:
		if room != ignore:
			get_parent().unload_room(room)
