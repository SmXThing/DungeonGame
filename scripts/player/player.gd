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

const sprint_multiplier: float = 1.5

var inventory: Array[Item]
var accessories: Array[Accessory]
var held_weapon: Weapon
var armor: Armor

var status: Array

func _ready() -> void:
	health_bar.value = player_health

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("KEY_A", "KEY_D", "KEY_W", "KEY_S")
	
	if direction:
		velocity = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed/4)
		velocity.y = move_toward(velocity.y, 0, movement_speed/4)
	
	move_and_slide()

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
