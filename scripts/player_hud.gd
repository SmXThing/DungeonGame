extends CanvasLayer

@export var player: CharacterBody2D
@onready var map: Map = $Map
@onready var minimap: Map = $MiniMap

func update_maps(room: Room) -> void:
	map.update_map(room)
	minimap.update_map(room)
