extends CanvasLayer

@onready var grid = $NinePatchRect/GridContainer
@onready var tooltip = $ItemTooltip
@onready var tooltip_name = $ItemTooltip/ItemName
@onready var tooltip_desc = $ItemTooltip/ItemDesc

@onready var sword_equipped: Sprite2D = $NinePatchRect/EquippedPanel/SwordEquipped
@onready var staff_equipped: Sprite2D = $NinePatchRect/EquippedPanel/StaffEquipped
@onready var bow_equipped: Sprite2D = $NinePatchRect/EquippedPanel/BowEquipped
@onready var slot_scene: PackedScene = load("res://scenes/ItemSlot.tscn")

var valid_equipped: Sprite2D

var player: Player

func _ready() -> void:
	for num in range(0, 36):
		var slot: Panel = slot_scene.instantiate()
		grid.add_child(slot)
		slot.button.mouse_entered.connect(func(): show_tooltip(slot.item))
		slot.button.mouse_exited.connect(func(): hide_tooltip())
		slot.button.pressed.connect(func(): consume_item(slot, slot.item))
	player = get_parent()
	hide()
	
	if globals.chest_weapon_type == "sword":
		valid_equipped = sword_equipped
	elif globals.chest_weapon_type == "bow":
		valid_equipped = bow_equipped
	elif globals.chest_weapon_type == "staff":
		valid_equipped = staff_equipped

func toggle() -> void:
	visible = not visible
	if visible:
		refresh()
	else:
		player.lock_idle = false

func refresh() -> void:
	var inventory_index: int = 0
	var slots: Array = grid.get_children()
	valid_equipped.texture = player.equipped.sprite.texture
	for slot in slots:
		if slot.item:
			slot.item = null
		slot.equipped_graphic.visible = false
	
	for item in player.inventory:
		slots[inventory_index].item = item
		slots[inventory_index].item_index = inventory_index
		if item is Potion:
			slots[inventory_index].potion_sprite.texture = item.sprite.texture
		else:
			if item == player.equipped:
				slots[inventory_index].equipped_graphic.show()
			slots[inventory_index].weapon_sprite.texture = item.sprite.texture
		inventory_index += 1

func show_tooltip(item: Item) -> void:
	print("ASf")
	if item:
		tooltip_name.text = item.item_name.to_upper()
		tooltip_desc.text = item.item_description.to_upper()
		tooltip.show()
	else:
		print("errr")

func hide_tooltip() -> void:
	tooltip.hide()

func consume_item(slot: Slot, item: Item) -> void:
	if item:
		if item is Potion:
			if player.status_num < 3:
				player.apply_status(item)
				player.inventory.remove_at(slot.item_index)
				for item_slot in grid.get_children():
					item_slot.reset()
					refresh()
		elif !player.is_attacking && item != player.equipped:
			if player is Melee:
				player.equipped = item
				if item.get_parent() == null:
					player.sword_marker.add_child(item)
			elif player is Mage:
				player.equipped = item
				if item.get_parent() == null:
					player.staff_marker.add_child(item)
			elif player is Ranger:
				player.equipped = item
				if item.get_parent() == null:
					player.bow_marker.add_child(item)
		refresh()
