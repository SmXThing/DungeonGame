extends State

signal switched_direction

var sprint_multiplier: float = 1.5
var sprinting: bool = false

func _ready() -> void:
	switched_direction.connect(_on_switched_direction)

func update(_delta: float) -> void:
	if player.velocity == Vector2(0, 0):
		animation_sprite.speed_scale = 1
		emit("idle")

func physics_update(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("KEY_A", "KEY_D", "KEY_W", "KEY_S")
	
	if direction:
		var switched: bool = false
		player.velocity = direction * player.movement_speed
		
		if Input.is_action_pressed("SHIFT"):
			player.velocity *= sprint_multiplier
			animation_sprite.speed_scale = sprint_multiplier
		else:
			animation_sprite.speed_scale = 1
		
		if direction.x != 0 && player.facing.x != round(direction.x):
			player.facing.x = round(direction.x)
			switched = true
		if direction.y != 0 && player.facing.y != round(direction.y):
			player.facing.y = round(direction.y)
			switched = true
		if switched:
			switched_direction.emit()
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_speed/4)
		player.velocity.y = move_toward(player.velocity.y, 0, player.movement_speed/4)

func enter() -> void:
	set_anim_direction(get_parent().get_last_direction())

func exit() -> void:
	pass

func _on_switched_direction() -> void:
	var new_direction: Vector2 = get_parent().get_last_direction()
	print(new_direction)
	set_anim_direction(new_direction)

func set_anim_direction(dir: Vector2):
	if dir.y == 1:
		animation_sprite.play("walking_down")
	else:
		animation_sprite.play("walking_up")
	if dir.x == 1:
		animation_sprite.flip_h = false
	else:
		animation_sprite.flip_h = true
