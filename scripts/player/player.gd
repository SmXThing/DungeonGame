extends CharacterBody2D
class_name Player

signal player_killed

@export var movement_speed: float
@export var player_health: int
@export var player_class: String
@export var inventory_space: int = 48
@export var health_bar: TextureProgressBar
@export var camera: Camera2D
@export var body_sprites: AnimatedSprite2D
@export var leg_sprites: AnimatedSprite2D
@export var arm_sprites: AnimatedSprite2D
@export var light: PointLight2D
@export var enable_camera_limit: bool = false
@export var HUD: CanvasLayer
@export var inventory_ui: CanvasLayer

const sprint_multiplier: float = 1.5

var inventory: Array[Item] = []
var accessories: Array[Accessory]
var equipped: Weapon

var is_attacking: bool = false

var status: Array
var time: float = 0
var facing: Vector2 = Vector2(1, 1)

func _ready() -> void:
	if enable_camera_limit:
		camera_translation(Vector2i(0, 0), 0)
	health_bar.value = player_health

func _physics_process(delta: float) -> void:
	time += delta
	light.energy = 1.16 + 0.2 * sin(4 * time)
	
	if Input.is_key_pressed(KEY_U):
		inventory.append(weapons.generate_random_weapon("sword"))
	
	move_and_slide()

func camera_translation(cell_pos: Vector2i, duration: float) -> void:
	var actual_pos = Vector2(cell_pos) * get_viewport_rect().size

	var tween_1 = create_tween()
	tween_1.tween_property(camera, "limit_left", actual_pos.x, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var tween_2 = create_tween()
	tween_2.tween_property(camera, "limit_right", actual_pos.x, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var tween_3 = create_tween()
	tween_3.tween_property(camera, "limit_top", actual_pos.y, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var tween_4 = create_tween()	
	tween_4.tween_property(camera, "limit_bottom", actual_pos.y, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func take_damage(damage: int) -> void:
	health_bar.value -= damage
	if health_bar.value < 1:
		player_killed.emit()

func add_item_to_inventory(item: Item) -> bool:
	if len(inventory) < inventory_space:
		inventory.append(item)
		return true
	else:
		print("Limit Reached")
		return false

func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("RoomTransition"):
		var room: Room = area.get_parent()
		if !room.traversed:
			room.traversed = true
			HUD.update_maps(room)
		if enable_camera_limit:
			camera_translation(room.cell, 1.5)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_inventory"):  # plan to set this to "i" key
		inventory_ui.toggle()
