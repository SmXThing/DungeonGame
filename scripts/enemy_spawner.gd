extends Marker2D

var enemy: PackedScene

func _ready() -> void:
	var rand_num = randi_range(0, 1)
	if rand_num == 0:
		enemy = load("res://scenes/OrcEnemy.tscn")
	else:
		enemy = load("res://scenes/WitchEnemy.tscn")
	
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
