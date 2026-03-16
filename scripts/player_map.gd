extends Map

@export var map_speed: float = 10.0
@export var camera: Camera2D
@export var player_icon: Sprite2D

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ESC"):
		visible = !visible
		if visible:
			move_map_to_player()
			get_tree().paused = true
		else:
			get_tree().paused = false
		
	if visible:
		if Input.is_action_pressed("KEY_W"):
			camera.position.y -= map_speed
		if Input.is_action_pressed("KEY_A"):
			camera.position.x -= map_speed
		if Input.is_action_pressed("KEY_S"):
			camera.position.y += map_speed
		if Input.is_action_pressed("KEY_D"):
			camera.position.x += map_speed
		
		if Input.is_action_pressed("CTRL"):
			if Input.is_action_pressed("ui_up"):
				camera.zoom += 0.025 * Vector2(1, 1)
			if Input.is_action_pressed("ui_down") && camera.zoom.x > 0.06:
				camera.zoom -= 0.025 * Vector2(1, 1)

func update_map(room: Room) -> void:
	visible_rooms[room.cell] = room.traversed
	
	for node in room.connected_cells:
		if node not in visible_rooms.keys():
			visible_rooms[node] = false

func display_map() -> void:
	for node in visible_rooms.keys():
		var graphic: Sprite2D = Sprite2D.new()
		if visible_rooms[node]:
			graphic.texture = load(traversed_path_graphic)
		else:
			graphic.texture = load(adjacent_path_graphic)
		graphic.position = origin_marker.position + Vector2(to_relative(node))
		map.add_child(graphic)

func move_map_to_player() -> void:
	player_icon.position = player.global_position / 2
	map.position = -player.global_position / 2
	camera.position = Vector2(0, 0)
	display_map()
