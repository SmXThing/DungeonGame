extends Node2D

'''
Room Gen Tips:
	Recommended to keep length and depth close in value.
'''
##Number of rooms in the path to the final boss room. Does not include the starting room.
@export_range(1, 1000) var length: int = 10
##Number of rooms that can generate additional paths. Creates the branches of the dungeon.
@export_range(0, 1000) var depth: int = 15
@export var camera_speed: int = 10
##Loads all rooms in the scene. (WARNING: Should only be enabled for smaller dungeons as larger dungeons can cause severe lag!)
@export var load_all: bool = false
@export var num_chests: int = 5
var enable_room_loading: bool = true
var var_camera_speed: int

var room_test: PackedScene = preload("res://scenes/TestRoom.tscn")

var map_data: Array[Array] = []

var cell_positions: Array[Vector2i] = []
var room_connections: Array[int] = []
var room_directions: Array[Array] = []
var room_file_paths: Array[String] = []
var room_names: Array[String] = []

var room_scenes: Dictionary[Vector2i, Room] = {}

var blocked_cells: Array[Vector2i] = []

var starting_room_cell: Vector2i
var boss_room_cell: Vector2i
var max_cells_remaining = depth

@export var scene_cover: ColorRect

func _ready() -> void:
	if globals.active_class != "Ranger":
		$PlayerRanger.queue_free()
	if globals.active_class != "Mage":
		$PlayerMage.queue_free()
	if globals.active_class != "Melee":
		$PlayerMelee.queue_free()
	
	var_camera_speed = camera_speed
	max_cells_remaining = depth
	
	var start_room: TextureRect = room_test.instantiate()
	start_room.global_position = Vector2(0, 0)
	add_child(start_room)
	
	cell_positions.append(to_cell(start_room.global_position))
	
	#Creates Path to Boss Room
	initialize_path()
	
	starting_room_cell = cell_positions[0]
	boss_room_cell = cell_positions[-1]
	
	for cell in cell_positions:
		if cell != boss_room_cell:
			generate_cells(cell)
	
	var index: int = 0
	
	for cell in cell_positions:
		add_room_data(cell)
		add_data_line(cell_positions[index], room_connections[index], room_directions[index], room_file_paths[index], room_names[index])
		index += 1
	
	index = 0
	
	for line in map_data:
		var path: String = room_file_paths[index] + "/" + room_names[index]
		
		var room_scene: PackedScene = load(path)
		var room: Room = room_scene.instantiate()
		room.cell = cell_positions[index]
		for dir in room_directions[index]:
			room.connected_cells.append(room.cell + dir)
		room.global_position = to_actual(room.cell)
		room.scene_path = path
		
		room_scenes[cell_positions[index]] = room
		index += 1
	
	var shuffled_cells: Array = cell_positions
	shuffled_cells.shuffle()
	
	var rooms_remaining: int = num_chests
	index = 0
	while rooms_remaining > 0:
		if shuffled_cells[index] != starting_room_cell && shuffled_cells[index] != boss_room_cell:
			room_scenes[shuffled_cells[index]].trigger_chest()
			rooms_remaining -= 1
		index += 1
	
	if load_all:
		for room in room_scenes.keys():
			load_room(room)
		enable_room_loading = false
	else:
		load_room(starting_room_cell)
	
	$Theme.play()
	var tween = create_tween()
	tween.tween_property(scene_cover, "color", Color(0, 0, 0, 0), 2)
	await get_tree().create_timer(2).timeout
	scene_cover.hide()

func to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(pos / Vector2(get_viewport_rect().size))

func to_actual(pos: Vector2i) -> Vector2:
	return Vector2(pos * Vector2i(get_viewport_rect().size))

func initialize_path() -> void:
	for num in range(0, length):
		var last_cell: Vector2i = cell_positions[-1]
		var new_cell: Vector2i
		
		var loop: bool = false
		
		for dir in globals.directions:
			if check_validity(last_cell + dir):
				loop = true
		
		if !loop:
			blocked_cells.append(last_cell)
			cell_positions.remove_at(-1)
		else:
			while loop:
				new_cell = last_cell + globals.directions[randi_range(0, len(globals.directions) - 1)]
				if new_cell not in cell_positions && check_validity(new_cell):
					cell_positions.append(new_cell)
					loop = false

func check_valid_occupancy(cell: Vector2i, root: Vector2i, ignore: Vector2i) -> bool:
	for dir in globals.directions:
		if cell + dir in cell_positions && cell + dir != root:
			if dir == ignore && randi_range(1, 2) == 2 && cell + dir != boss_room_cell:
				continue
			else:
				return false
	return true

func check_adjacent_tiles(cell: Vector2i) -> bool:
	for dir in globals.directions:
		if cell + dir in cell_positions && cell + dir != cell_positions[-1]:
			return true
	return false

func check_validity(cell: Vector2i) -> bool:
	return !check_adjacent_tiles(cell) && !(cell in blocked_cells)

func get_available_cells(cell: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for dir in globals.directions:
		if cell + dir not in cell_positions:
			if check_valid_occupancy(cell + dir, cell, dir):
				cells.append(cell + dir)
	return cells

func generate_cells(root_cell: Vector2i) -> void:
	if max_cells_remaining > 0:
		var valid_cells: Array[Vector2i] = get_available_cells(root_cell)
		var dir_num: int = randi_range(1, 3)
		
		if len(valid_cells) > 0:
			if dir_num >= len(valid_cells):
				for cell in valid_cells:
					cell_positions.append(cell)
					max_cells_remaining -= 1
			elif dir_num > 0:
				for num in range(0, dir_num):
					cell_positions.append(valid_cells[num])
					max_cells_remaining -= 1

func add_room_data(root_cell: Vector2i) -> void:
	'''
	globals.directions:
		4 - Ignore, Only 1 Orientation
		3 - UP, RIGHT, DOWN [(0, -1), (1, 0), (0, 1)]
		2(Straight) - [(0, -1), (0, 1)]
		2(Corner) - [(0, -1), (1, 0)]
		1 - [(0, -1)]
	'''
	
	var connections: int = 0
	var connected_directions: Array[Vector2i] = []
	
	var rotations: int = 0
	var path: String = "res://rooms/"
	var room_name: String = "room_"
	
	for dir in globals.directions:
		if root_cell + dir in cell_positions:
			connections += 1
			connected_directions.append(dir)
	
	path += str(connections) + "/"
	room_name += str(connections) + "-"
	
	room_connections.append(connections)
	room_directions.append(connected_directions)
	
	if connections == 1:
		for dir in globals.directions:
			if connected_directions[0] == dir:
				path += str(rotations)
				room_name += str(rotations) + "_"
			else:
				rotations += 1
	elif connections == 2:
		if connected_directions[0] == -connected_directions[1]:
			path += "straight/"
			room_name += "S"
			if connected_directions[0] == Vector2i.UP:
				path += "0"
				room_name += "0_"
			else:
				path += "1"
				room_name += "1_"
		else:
			path += "corner/"
			room_name += "C"
			for num in range(0, 4):
				for it in range(0, len(connected_directions)):
					if connected_directions[it] not in [Vector2i(Vector2(0, -1).rotated(PI/2 * num)), Vector2i(Vector2(1, 0).rotated(PI/2 * num))]:
						rotations += 1
						break
					elif it + 1 == len(connected_directions):
						path += str(rotations)
						room_name += str(rotations) + "_"
	elif connections == 3:
		for num in range(0, 4):
			for it in range(0, len(connected_directions)):
				if connected_directions[it] not in [Vector2i(Vector2(0, -1).rotated(PI/2 * num)), Vector2i(Vector2(1, 0).rotated(PI/2 * num)), Vector2i(Vector2(0, 1).rotated(PI/2 * num))]:
					rotations += 1
					break
				elif it + 1 == len(connected_directions):
					path += str(rotations)
					room_name += str(rotations) + "_"
	elif connections == 4:
		path += "center"
		room_name += "0_"
	
	if root_cell == starting_room_cell:
		path += "/start/"
		room_name += "1"
	elif root_cell == boss_room_cell:
		path += "/boss/"
		room_name += "2"
	else:
		room_name += "0"
	
	var variation: int = randi_range(1, globals.get_num_files(path, "tscn"))
	room_name += str(variation) + ".tscn"
	
	room_file_paths.append(path)
	room_names.append(room_name)

func add_data_line(cell: Vector2i, connects: int, dirs: Array, path: String, room_name: String) -> void:
	var data: Array = [cell, connects, dirs, path, room_name]
	map_data.append(data)

func load_room(cell: Vector2i) -> void:
	if enable_room_loading:
		call_deferred("add_child", room_scenes[cell])

func unload_room(cell: Vector2i) -> void:
	if enable_room_loading:
		var room_copy: Room = copy_room(room_scenes[cell])
		room_scenes[cell].queue_free()
		room_scenes[cell] = room_copy

func copy_room(room: Room) -> Room:
	var root_scene: PackedScene = load(room.get_scene_path())
	var updated_room: Room = root_scene.instantiate()
	updated_room.cell = room.cell
	for cell in room.connected_cells:
		updated_room.connected_cells.append(cell)
	updated_room.global_position = to_actual(room.get_cell_pos())
	updated_room.scene_path = room.get_scene_path()
	updated_room.traversed = room.traversed
	
	return updated_room

func display_room_info() -> void:
	print("----------------------------------------------------------------")
	for room in room_scenes.keys():
		print("(Type: " + str(room_scenes[room].get_class()) + ") " + "Key: " + str(room) + "Actual Cell: " + str(room_scenes[room].cell) + " - Path: " + room_scenes[room].get_scene_path() + " - Adjacent Cells: " + str(room_scenes[room].connected_cells))

func exit() -> void:
	scene_cover.show()
	var tween = create_tween()
	tween.tween_property(scene_cover, "color", Color(0, 0, 0, 1), 4)
	await get_tree().create_timer(4).timeout
	get_tree().call_deferred("change_scene_to_file", "res://MENUS/SCENES/class_selection_menu.tscn")
