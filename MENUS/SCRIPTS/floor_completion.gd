extends Control

var score = 0
var grade = "C"

func _ready():
	'''$VBoxContainer/NextFloor.pressed.connect(_on_next)
	$VBoxContainer/Retry.pressed.connect(_on_retry)'''
	$VBoxContainer/MainMenu.pressed.connect(_on_menu)

	update_display()

func update_display():
	$VBoxContainer/Score.text = "Score: %d" % score
	$VBoxContainer/Grade.text = "Grade: %s" % grade

func set_results(p_score, p_grade):
	score = p_score
	grade = p_grade
	
'''func _on_next():
	DONT WORRY ABOUT THIS
	var next_level = LevelManager.current_level_id + 1
		 LevelManager.load_level(next_level)

func _on_retry():
	LevelManager.load_level(LevelManager.current_level_id)'''

func _on_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func complete_level():
	var score = 1500
	var grade = "A"

	var scene = load("res://floor_completion.tscn").instantiate()
	get_tree().root.add_child(scene)

	scene.set_results(score, grade)

	get_tree().current_scene.queue_free()
