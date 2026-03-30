extends Control
class_name Menu

@export var scene_cover: ColorRect

func enter() -> void:
	var tween = create_tween()
	tween.tween_property(scene_cover, "color", Color(0, 0, 0, 0), 2)
	await get_tree().create_timer(2).timeout
	scene_cover.hide()

func transit_to_scene(scene_path: String) -> void:
	scene_cover.show()
	var tween = create_tween()
	tween.tween_property(scene_cover, "color", Color(0, 0, 0, 1), 2)
	await get_tree().create_timer(2).timeout
	get_tree().call_deferred("change_scene_to_file", scene_path)
