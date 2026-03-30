extends State

func update(_delta: float) -> void:
	if !player.is_attacking:
		if Input.is_action_pressed("ENTER") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if player.velocity.x < 0:
				player.facing.x = -1
			else:
				player.facing.x = 1
			enter()
		else:
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
	if player is Melee:
		arms.stop()
		arms.show()
		player.arm_group.show()
		
		arms.play("swing")
		body.play("swing")
		
		if player.facing.x > 0:
			body.flip_h = false
		else:
			body.flip_h = true
		
		if player.velocity == Vector2(0, 0):
			legs.play("swing")
		elif legs.animation != "walking_down" || legs.animation != "walking_up":
			if player.facing.x > 0:
				legs.flip_h = false
			else:
				legs.flip_h = true
			legs.play("walking_down")
		player.swing_sword()

func exit() -> void:
	pass
