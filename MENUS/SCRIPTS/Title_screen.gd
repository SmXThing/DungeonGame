extends Menu

var can_press := false
@onready var text: Label = $Label

func _ready():
	text.hide()
	enter()
	await get_tree().create_timer(2).timeout
	text.show()
	can_press = true
	
func _input(event):
	if can_press:
		if Input.is_anything_pressed():
			transit_to_scene("res://MENUS/SCENES/class_selection_menu.tscn")
