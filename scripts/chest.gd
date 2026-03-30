extends CharacterBody2D

'''
Notes:
	Item TypeID 0 = Potion
	Item TypeID 1 = Weapon
	Item TypeID 2 = Accessory (May or May Not Be Accessible)
	
	Item Array Structure: ItemTypeID, Variation, Info, Rarity
'''

var opened: bool = false

var item_type: String
var item_variation: String
var item_info: Array
var item_rarity: String

var weapon_type: String = globals.chest_weapon_type
var num_potions: int = 3

var weapon: Array
var potion_list: Array[Array] = []

var time: float

@onready var sprites: AnimatedSprite2D = $Sprites

func _ready() -> void:
	sprites.play("default")
	set_process(false)
	weapon = weapons.generate_random_weapon(weapon_type)
	for num in range(0, num_potions):
		potion_list.append(potions.generate_random_potion())

func _process(delta: float) -> void:
	time += delta * 3
	modulate = (0.4 * (sin(time) * sin(time)) + 1) * Color(1, 1, 1, 1)
	if Input.is_action_just_pressed("KEY_E"):
		open_chest()

func open_chest() -> void:
	opened = true
	set_process(false)
	sprites.play("open")
	create_drop("Weapon", weapon)
	for potion in potion_list:
		create_drop("Potion", potion)

func create_drop(type: String, item_data: Array) -> void:
	var drop: Drop = Drop.new()
	drop.item_type = type
	
	if type == "Weapon":
		drop.item_variation = weapon_type
		drop.item_info = item_data[2]
		print("res://weapons/" + weapon_type + "s/" + drop.item_info[0] + ".png")
		drop.sprite_path = "res://weapons/" + weapon_type + "s/" + drop.item_info[0] + ".png"
		drop.rarity = item_data[3]
	elif type == "Potion":
		drop.item_info = item_data[1]
		drop.sprite_path = drop.item_info[3]
		drop.rarity = item_data[2]
	add_child(drop)

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && !opened:
		set_process(true)

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_process(false)
		modulate = Color(1, 1, 1, 1)
