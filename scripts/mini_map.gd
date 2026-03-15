extends Node2D

@onready var player = get_parent().player
@onready var map: Node2D = $MapElements/ViewportContainer/MapViewport/Graphics
@onready var origin_marker = $MapElements/ViewportContainer/MapViewport/Graphics/Origin

var visible_rooms: Dictionary[Vector2i, bool] = {}

func _ready() -> void:
	if !player:
		print("error!")
	modulate.a = 0.5

func _process(_delta: float) -> void:
	map.position = -player.global_position / 2
	if Input.is_action_just_pressed("TAB"):
		visible = !visible

func to_relative(cell: Vector2i) -> Vector2i:
	return cell * Vector2i(get_viewport_rect().size) / 2

func update_map(room: Room) -> void:
	visible_rooms[room.cell] = room.traversed
	
	for node in room.connected_cells:
		if node not in visible_rooms.keys():
			visible_rooms[node] = false
	
	for node in visible_rooms.keys():
		var graphic: Sprite2D = Sprite2D.new()
		if visible_rooms[node]:
			graphic.texture = load("res://assets/MapPlaceholder.png")
		else:
			graphic.texture = load("res://assets/MapPlaceholder2.png")
		graphic.position = origin_marker.position + Vector2(to_relative(node))
		map.add_child(graphic)
