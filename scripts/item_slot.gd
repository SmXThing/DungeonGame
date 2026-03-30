extends Panel
class_name Slot

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var potion_sprite: Sprite2D = $PotionSprite
@onready var equipped_graphic: Sprite2D = $EquippedGraphic
@onready var button: Button = $Button

var item: Item
var equipped: bool = false
var item_index: int

func _ready() -> void:
	equipped_graphic.hide()
	if globals.chest_weapon_type == "sword":
		weapon_sprite.position = Vector2(5, 11)
	elif globals.chest_weapon_type == "bow":
		weapon_sprite.position = Vector2(10, 8)
	elif globals.chest_weapon_type == "staff":
		weapon_sprite.position = Vector2(5, 11)

func reset() -> void:
	item = Item.new()
	equipped = false
	weapon_sprite.texture = CompressedTexture2D.new()
	potion_sprite.texture = CompressedTexture2D.new()
