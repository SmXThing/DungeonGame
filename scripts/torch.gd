extends AnimatedSprite2D

var it: int = randi_range(0, 3)

@onready var light: PointLight2D = $Light

func _ready() -> void:
	frame = it
	play("default")

func _on_flicker_timer_timeout() -> void:
	var rad: float = PI/2 * it
	light.energy = 1 + 0.1 * sin(rad)
	it += 1
