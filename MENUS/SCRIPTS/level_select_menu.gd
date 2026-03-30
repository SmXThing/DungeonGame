extends Menu

@onready var bg = $Background
@onready var level_1_button = $CenterContainer/VBoxContainer/GridContainer/Level1Button
@onready var level_2_button = $CenterContainer/VBoxContainer/GridContainer/Level2Button
@onready var level_3_button = $CenterContainer/VBoxContainer/GridContainer/Level3Button
@onready var level_4_button = $CenterContainer/VBoxContainer/GridContainer/Level4Button

func _ready():
	enter()

func _on_level_1_pressed():
	transit_to_scene("res://scenes/Floor1.tscn")

func _on_level_2_pressed():
	transit_to_scene("res://scenes/Floor2.tscn")
