extends State

func update(_delta: float) -> void:
	if !player.is_attacking:
		if player.velocity == Vector2(0, 0):
			emit("idle")
		else:
			emit("walking")

func physics_update(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("KEY_A", "KEY_D", "KEY_W", "KEY_S")
	
	if direction:
		player.velocity = direction * player.movement_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_speed/4)
		player.velocity.y = move_toward(player.velocity.y, 0, player.movement_speed/4)

func enter() -> void:
	if player is Ranger:
		var direction: Vector2 = (player.get_global_mouse_position() - player.bow_marker.global_position).normalized()
		
		if direction.x < 0:
			body.flip_h = true
			legs.flip_h = true
		else:
			body.flip_h = false
			legs.flip_h = false
			
		player.arm.show()
		body.play("shoot")
		
		if player.velocity == Vector2(0, 0):
			legs.play("shoot")
		elif legs.animation != "walking_down" || legs.animation != "walking_up":
			legs.play("walking_down")
		
		player.shoot(direction)

func exit() -> void:
	pass
