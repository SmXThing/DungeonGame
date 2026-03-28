extends CanvasLayer

@onready var grid = $Panel/GridContainer
@onready var tooltip = $Panel/ItemTooltip
@onready var tooltip_name = $Panel/ItemTooltip/ItemName
@onready var tooltip_desc = $Panel/ItemTooltip/ItemDesc

var slot_scene = preload("res://scenes/ItemSlot.tscn")
var player: Player

func _ready() -> void:
	player = get_parent()
	hide()  # hidden by default

func toggle() -> void:
	visible = not visible
	if visible:
		refresh()

func refresh() -> void:
	for child in grid.get_children():
		child.queue_free()
	for item in player.inventory:
		var slot = slot_scene.instantiate()
		if item.sprite != null:
			slot.texture_normal = item.sprite.texture
		else:
			slot.texture_normal = load("res://assets/swordguy.png")
		slot.mouse_entered.connect(func(): show_tooltip(item))
		slot.mouse_exited.connect(func(): hide_tooltip())
		grid.add_child(slot)

func show_tooltip(item: Item) -> void:
	tooltip_name.text = item.item_name
	tooltip_desc.text = item.item_description
	tooltip.show()

func hide_tooltip() -> void:
	tooltip.hide()
