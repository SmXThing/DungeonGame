extends Control

var can_press := false

func _ready():
	$TitleButton.mouse_entered.connect(_on_hover)
	$TitleButton.mouse_exited.connect(_on_exit)
	$TitleButton.pressed.connect(_on_title_pressed)
	
	await get_tree().create_timer(0.5).timeout
	can_press = true
	
func _input(event):
	if not can_press:
		return
	
	if event.is_pressed():
		_on_title_pressed()
	
func _on_title_pressed():
	get_tree().change_scene_to_file("res://MENUS/SCENES/main_menu.tscn")
	
func _on_hover():
	$TitleButton.scale = Vector2(1.1, 1.1)

func _on_exit():
	$TitleButton.scale = Vector2(1, 1)
