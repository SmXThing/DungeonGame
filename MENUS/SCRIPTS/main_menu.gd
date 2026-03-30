extends Control

func _ready():
	for button in $VBoxContainer.get_children():
		button.mouse_entered.connect(func(): button.scale = Vector2(1.1, 1.1))
		button.mouse_exited.connect(func(): button.scale = Vector2(1, 1))

	$VBoxContainer/StartGame.pressed.connect(_on_start)
	$VBoxContainer/Options.pressed.connect(_on_options)
	$VBoxContainer/Exit.pressed.connect(_on_exit)

func _on_start():
	get_tree().change_scene_to_file("res://menus/LevelSelectMenu.tscn")

func _on_options():
	print("Options menu not made yet")  # we’ll build this later

func _on_exit():
	get_tree().quit()
