extends Menu

@onready var mage_button: Button = $HBoxContainer/Mage
@onready var melee_button: Button = $HBoxContainer/Melee
@onready var ranger_button: Button = $HBoxContainer/Ranger

func _ready() -> void:
	enter()

func _on_mage_pressed() -> void:
	globals.active_class = "Mage"
	globals.chest_weapon_type = "staff"
	transit_to_scene("res://MENUS/SCENES/level_select_menu.tscn")

func _on_melee_pressed() -> void:
	globals.active_class = "Melee"
	globals.chest_weapon_type = "sword"
	transit_to_scene("res://MENUS/SCENES/level_select_menu.tscn")

func _on_ranger_pressed() -> void:
	globals.active_class = "Ranger"
	globals.chest_weapon_type = "bow"
	transit_to_scene("res://MENUS/SCENES/level_select_menu.tscn")
