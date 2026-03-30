extends State

func update(_delta: float) -> void:
	if !player.lock_idle:
		if Input.is_action_pressed("KEY_W") || Input.is_action_pressed("KEY_A") || Input.is_action_pressed("KEY_S") || Input.is_action_pressed("KEY_D"):
			emit("walking")
		if Input.is_action_pressed("ENTER") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			emit("attacking")

func physics_update(_delta: float) -> void:
	pass

func enter() -> void:
	if get_parent().get_last_direction().y == -1:
		body.play("idle_up")
		legs.play("idle_up")
	else:
		body.play("idle_down") 
		legs.play("idle_down") 
	if get_parent().get_last_direction().x == 1:
		body.flip_h = false
		legs.flip_h = false
	else:
		body.flip_h = true
		legs.flip_h = true

func exit() -> void:
	pass
