extends CharacterBody2D
class_name Player

signal player_killed

@export var movement_speed: float
@export var player_health: int
@export var player_class: String
@export var inventory_space: int = 48
@export var health_bar: TextureProgressBar
@export var camera: Camera2D
@export var sprites: AnimatedSprite2D
@export var light: PointLight2D
@export var enable_camera_limit: bool = false

const sprint_multiplier: float = 1.5

var inventory: Array[Item]
var accessories: Array[Accessory]
var held_weapon: Weapon
var armor: Armor

var status: Array
var time: float = 0

func _ready() -> void:
	if enable_camera_limit:
		camera_translation(Vector2i(0, 0), 0)
	health_bar.value = player_health

func _physics_process(delta: float) -> void:
	time += delta
	light.energy = 1.16 + 0.2 * sin(4 * time)
	
	var direction: Vector2 = Input.get_vector("KEY_A", "KEY_D", "KEY_W", "KEY_S")
	
	if direction:
		velocity = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed/4)
		velocity.y = move_toward(velocity.y, 0, movement_speed/4)
	
	move_and_slide()

func camera_translation(cell_pos: Vector2i, duration: float) -> void:
	var actual_pos = Vector2(cell_pos) * get_viewport_rect().size
	var tween_1 = create_tween()
	var tween_2 = create_tween()
	var tween_3 = create_tween()
	var tween_4 = create_tween()
	tween_1.tween_property(camera, "limit_left", actual_pos.x, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween_2.tween_property(camera, "limit_right", actual_pos.x, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween_3.tween_property(camera, "limit_top", actual_pos.y, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
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
	if area.is_in_group("RoomTransition") && enable_camera_limit:
		camera_translation(area.get_parent().get_cell_pos(), 2.0)
