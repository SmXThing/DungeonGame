extends CharacterBody2D
class_name Drop

var item_type: String
var item_variation: String
var item_info: Array
var rarity: String
var sprite_path: String

var collision_box: CollisionShape2D = CollisionShape2D.new()
var pickup_area: Area2D = Area2D.new()
var pickup_box: CollisionShape2D = CollisionShape2D.new()
var sprite: Sprite2D = Sprite2D.new()

var item_gravity = randf_range(0.75, 1.5) * 5

func _ready() -> void:
	collision_box.shape = RectangleShape2D.new()
	collision_box.shape.size = Vector2(4, 1)
	add_child(collision_box)
	
	pickup_area.connect("body_entered", _on_pickup_body_entered)
	add_child(pickup_area)
	
	pickup_box.shape = RectangleShape2D.new()
	pickup_box.shape.size = Vector2(4, 4)
	pickup_area.add_child(pickup_box)
	
	sprite.texture = load(sprite_path)
	sprite.scale = 0.5 * Vector2(1, 1)
	add_child(sprite)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(7, true)
	
	velocity.y = -100
	velocity.x = randi_range(-75, 75)
	await get_tree().create_timer(1.0).timeout
	pickup_area.set_collision_mask_value(2, true)

func _physics_process(_delta: float) -> void:
	if !is_on_floor() && velocity.y < 125:
		velocity.y += item_gravity
	if velocity.x != 0:
		velocity.x = move_toward(velocity.x, 0, 1)
	
	move_and_slide()
func _on_pickup_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player: Player = body
		
		if item_type == "Potion":
			player.add_item_to_inventory(potions.compile_potion(item_info, rarity))
		elif item_type == "Weapon":
			var weapon: Weapon = weapons.compile_weapon(item_variation, item_info, rarity)
			player.add_item_to_inventory(weapon)
		
		queue_free()
