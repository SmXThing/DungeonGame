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
	if player is Mage:
		var player_direction: Vector2 = (player.get_global_mouse_position() - player.global_position).normalized()
		var focal_point_pos: Vector2 = player.equipped.focal_point
		focal_point_pos.x += player.staff_marker.position.x
		
		if player_direction.x < 0:
			body.flip_h = true
			legs.flip_h = true
			focal_point_pos.x *= -1
		else:
			body.flip_h = false
			legs.flip_h = false
		
		var projectile_direction: Vector2 = (player.get_global_mouse_position() - (player.global_position + focal_point_pos)).normalized()
		
		player.arm.show()
		body.play("shoot")
		
		if player.velocity == Vector2(0, 0):
			legs.play("shoot")
		elif legs.animation != "walking_down" || legs.animation != "walking_up":
			legs.play("walking_down")
		
		player.fire(projectile_direction, player_direction)

func exit() -> void:
	pass
