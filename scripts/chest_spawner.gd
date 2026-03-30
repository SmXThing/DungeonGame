extends Marker2D



func spawn(opened: bool) -> void:
	var chest: PackedScene = load("res://scenes/Chest.tscn")
	var chest_instance: CharacterBody2D = chest.instantiate()

	chest_instance.weapon_type = globals.chest_weapon_type
	chest_instance.opened = opened
	add_child(chest_instance)
