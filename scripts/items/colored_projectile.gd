extends Projectile

var color: Color = Color(1, 1, 1, 1)

func _ready() -> void:
	sprite.modulate = color
