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

var status_num: int
var time: float = 0
var facing: Vector2 = Vector2(1, 1)

var strength: int = 1
var endurance: int = 1

var lock_idle: bool = false

func _ready() -> void:
	if enable_camera_limit:
		camera_translation(Vector2i(0, 0), 0)
	health_bar.value = player_health

func _physics_process(delta: float) -> void:
	time += delta
	light.energy = 1.16 + 0.2 * sin(4 * time)
	
	if Input.is_key_pressed(KEY_U) && Input.is_action_just_pressed("CTRL"):
		inventory.append(weapons.get_legendary_item())
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
	HUD.health_bar.value -= damage
	if HUD.health_bar.value < 1:
		get_parent().exit()

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
	if event.is_action_pressed("ui_inventory") && !is_attacking:  # plan to set this to "i" key
		lock_idle = true
		inventory_ui.toggle()

func apply_status(potion: Potion) -> void:
	if potion.type == "Health":
		if potion.mod + HUD.health_bar.value > player_health:
			HUD.health_bar.value = player_health
		else:
			HUD.health_bar.value += potion.mod
		return
	
	status_num += 1
	
	if potion.type == "Strength":
		strength += potion.mod
		await get_tree().create_timer(potion.duration).timeout
		strength -= potion.mod
	elif potion.type == "Speed":
		movement_speed += potion.mod
		await get_tree().create_timer(potion.duration).timeout
		movement_speed -= potion.mod
	elif potion.type == "Endurance":
		endurance += potion.mod
		await get_tree().create_timer(potion.duration).timeout
		endurance -= potion.mod
	
	status_num -= 1
