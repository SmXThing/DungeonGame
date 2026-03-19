extends State

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("KEY_W") || Input.is_action_just_pressed("KEY_A") || Input.is_action_just_pressed("KEY_S") || Input.is_action_just_pressed("KEY_D"):
		emit("walking")
	'''if Input.is_action_just_pressed("ENTER") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		emit("attacking")'''

func physics_update(_delta: float) -> void:
	pass

func enter() -> void:
	if get_parent().get_last_direction().y == -1:
		animation_sprite.play("idle_up")
	else:
		animation_sprite.play("idle_down") 
	if get_parent().get_last_direction().x == 1:
		animation_sprite.flip_h = false
	else:
		animation_sprite.flip_h = true

func exit() -> void:
	pass
