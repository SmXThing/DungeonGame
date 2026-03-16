extends Node2D
class_name Map

@export var traversed_path_graphic: String
@export var adjacent_path_graphic: String
@export var map: Node2D
@export var origin_marker: Marker2D

@onready var player = get_parent().player

var visible_rooms: Dictionary[Vector2i, bool] = {}

func to_relative(cell: Vector2i) -> Vector2i:
	return cell * Vector2i(get_viewport_rect().size) / 2
