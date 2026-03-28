extends State

func update(_delta: float) -> void:
	if !player.is_attacking:
		emit("idle")

func physics_update(_delta: float) -> void:
	pass

func enter() -> void:
	if player is Melee:
		player.swing_sword()

func exit() -> void:
	pass
