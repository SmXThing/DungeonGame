extends Control

@onready var bg = $Background
@onready var level_1_button = $CenterContainer/VBoxContainer/GridContainer/Level1Button
@onready var level_2_button = $CenterContainer/VBoxContainer/GridContainer/Level2Button
@onready var level_3_button = $CenterContainer/VBoxContainer/GridContainer/Level3Button
@onready var level_4_button = $CenterContainer/VBoxContainer/GridContainer/Level4Button
@onready var back_button = $CenterContainer/VBoxContainer/BackButton

func _ready():
	bg.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 1.0, 1.0)

	level_1_button.text = "Placeholder text"
	level_2_button.text = "Placeholder text"
	level_3_button.text = "Coming Soon"
	level_4_button.text = "Coming Soon"

	level_3_button.disabled = true
	level_4_button.disabled = true

	level_1_button.pressed.connect(_on_level_1_pressed)
	level_2_button.pressed.connect(_on_level_2_pressed)
	back_button.pressed.connect(_on_back_pressed)

	for button in [level_1_button, level_2_button, level_3_button, level_4_button, back_button]:
		button.mouse_entered.connect(func(): button.scale = Vector2(1.05, 1.05))
		button.mouse_exited.connect(func(): button.scale = Vector2(1, 1))

func _on_level_1_pressed():
	print("Dungeon 01 selected")

func _on_level_2_pressed():
	print("Dungeon 02 selected")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://MENUS/SCENES/main_menu.tscn")
