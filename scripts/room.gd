extends Node2D
class_name Room

var cell: Vector2i
var connected_cells: Array[Vector2i]

func get_cell_pos() -> Vector2i:
	return cell

func _on_detection_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		pass
