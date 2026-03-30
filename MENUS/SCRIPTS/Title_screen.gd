extends Control

func _ready():
	$TitleButton.mouse_entered.connect(_on_hover)
	$TitleButton.mouse_exited.connect(_on_exit)
	$TitleButton.pressed.connect(_on_title_pressed)

func _on_title_pressed():
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn")
	
func _on_hover():
	$TitleButton.scale = Vector2(1.1, 1.1)

func _on_exit():
	$TitleButton.scale = Vector2(1, 1)
