extends Control

@onready var bg = $Background

func _ready():
	bg.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 1.0, 1.5)
