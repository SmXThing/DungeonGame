extends Map

func _ready() -> void:
	if !player:
		print("error!")
	modulate.a = 0.5

func _process(_delta: float) -> void:
	map.position = -player.global_position / 2
	if Input.is_action_just_pressed("TAB"):
		visible = !visible

func update_map(room: Room) -> void:
	visible_rooms[room.cell] = room.traversed
	
	for node in room.connected_cells:
		if node not in visible_rooms.keys():
			visible_rooms[node] = false
	
	for node in visible_rooms.keys():
		var graphic: Sprite2D = Sprite2D.new()
		if visible_rooms[node]:
			graphic.texture = load(traversed_path_graphic)
		else:
			graphic.texture = load(adjacent_path_graphic)
		graphic.position = origin_marker.position + Vector2(to_relative(node))
		map.add_child(graphic)
