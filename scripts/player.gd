extends CharacterBody2D

# Define movement speed
const SPEED = 300

func _physics_process(delta):
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Set the velocity
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		# Optional: Add deceleration when no input is detected (e.g., using lerp)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Move the character and handle collisions
	move_and_slide()
