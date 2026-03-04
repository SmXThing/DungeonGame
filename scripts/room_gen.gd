extends Node2D

@export var length: int
@export var depth: int

var room_test: PackedScene = preload("res://scenes/TestRoom.tscn")

var map_data: Array = []

var cell_positions: Array = []
var room_connections: Array = []
var room_directions: Array = []
var room_file_paths: Array = []

var blocked_cells: Array = []

var starting_room_cell: Vector2i
var boss_room_cell: Vector2i
var max_cells_remaining = depth

const directions: Array = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT
]

func _ready() -> void:
	max_cells_remaining = depth
	
	var start_room: Node2D = room_test.instantiate()
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
		
		add_data_line(cell_positions[index], room_connections[index], room_directions[index])
		
		var room_instance = room_test.instantiate()
		room_instance.global_position = to_actual(cell)
		
		if cell == starting_room_cell || cell == boss_room_cell:
			room_instance.modulate = Color.RED
		add_child(room_instance)
		index += 1
	
	for line in map_data:
		print(line)

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_W):
		$Camera2D.global_position += Vector2.UP * 100
	if Input.is_key_pressed(KEY_A):
		$Camera2D.global_position += Vector2.LEFT * 100
	if Input.is_key_pressed(KEY_S):
		$Camera2D.global_position += Vector2.DOWN * 100
	if Input.is_key_pressed(KEY_D):
		$Camera2D.global_position += Vector2.RIGHT * 100

func to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(pos / Vector2(get_viewport_rect().size))

func to_actual(pos: Vector2i) -> Vector2:
	return Vector2(pos * Vector2i(get_viewport_rect().size))

func initialize_path() -> void:
	for num in range(0, length):
		var last_cell: Vector2i = cell_positions[-1]
		var new_cell: Vector2i
		
		var loop: bool = false
		
		for dir in directions:
			if check_validity(last_cell + dir):
				loop = true
		
		if !loop:
			blocked_cells.append(last_cell)
			cell_positions.remove_at(-1)
		else:
			while loop:
				new_cell = last_cell + directions[randi_range(0, len(directions) - 1)]
				if new_cell not in cell_positions && check_validity(new_cell):
					cell_positions.append(new_cell)
					loop = false

func check_valid_occupancy(cell: Vector2i, root: Vector2i, ignore: Vector2i) -> bool:
	for dir in directions:
		if cell + dir in cell_positions && cell + dir != root && dir != ignore:
			return false
	return true

func check_adjacent_tiles(cell: Vector2i) -> bool:
	for dir in directions:
		if cell + dir in cell_positions && cell + dir != cell_positions[-1]:
			return true
	return false

func check_validity(cell: Vector2i) -> bool:
	return !check_adjacent_tiles(cell) && !(cell in blocked_cells)

func get_available_cells(cell: Vector2i) -> Array:
	var cells = []
	for dir in directions:
		if cell + dir not in cell_positions:
			if check_valid_occupancy(cell + dir, cell, dir):
				cells.append(cell + dir)
	return cells

func generate_cells(root_cell: Vector2i) -> void:
	if max_cells_remaining > 0:
		var valid_cells: Array = get_available_cells(root_cell)
		var dir_num = randi_range(1, 3)
		
		if len(valid_cells) > 0:
			if dir_num > len(valid_cells):
				for cell in valid_cells:
					cell_positions.append(cell)
					max_cells_remaining -= 1
			elif dir_num > 0:
				for num in range(0, dir_num):
					cell_positions.append(valid_cells[num])
					max_cells_remaining -= 1

func add_room_data(root_cell: Vector2i) -> void:
	'''
	Directions:
		4 - Ignore, Only 1 Orientation
		3 - UP, RIGHT, DOWN [(0, -1), (1, 0), (0, 1)]
		2(Straight) - [(0, -1), (0, 1)]
		2(Corner) - [(0, -1), (1, 0)]
		1 - [(0, -1)]
	'''
	
	
	var connections: int = 0
	var connected_directions: Array = []
	
	var rotations: int = 0
	var path: String = "res://rooms/"
	
	for dir in directions:
		if root_cell + dir in cell_positions:
			connections += 1
			connected_directions.append(dir)
	
	path += str(connections) + "/"
	
	room_connections.append(connections)
	room_directions.append(connected_directions)
	
	if connections == 1:
		for dir in directions:
			if room_connections[0] == dir:
				path += str(connections) + "/" + str(rotations)
			else:
				rotations += 1
	elif connections == 2:
		if room_directions[0] == -room_directions[1]:
			path += "straight/"
			if room_directions[0] == Vector2i.UP:
				path += "0"
			else:
				path += "1"
		else:
			for num in range(1, 5):
				pass
	
	'''match connections:
		1:
			match connected_directions[0]:
				Vector2i.UP:
					path += "cap_up.png"
					return
				Vector2i.RIGHT:
					path += "cap_right.png"
					return
				Vector2i.LEFT:
					path += "cap_left.png"
					return
				Vector2i.DOWN:
					path += "cap_down.png"
					return
		2:
			
			return
		3:
			return
		4:
			return
		_:
			print("ERROR - LINE 158")'''
	
	

func add_data_line(cell: Vector2i, connects: int, dirs: Array) -> void:
	var data: Array = [cell, connects, dirs]
	map_data.append(data)
