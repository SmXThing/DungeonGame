extends CanvasLayer

@export var player: Player
@onready var map: Map = $Map
@onready var minimap: Map = $MiniMap
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	health_bar.max_value = player.player_health
	health_bar.value = health_bar.max_value

func update_maps(room: Room) -> void:
	map.update_map(room)
	minimap.update_map(room)
