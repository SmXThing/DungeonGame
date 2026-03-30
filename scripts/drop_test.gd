extends Node2D

func _ready() -> void:
	for num in range(0, 6):
		var itemdata: Array = weapons.generate_random_weapon("sword")
		var drop: Drop = Drop.new()
		drop.item_type = "Weapon"
		drop.item_variation = itemdata[1]
		drop.item_info = itemdata[2]
		drop.sprite_path = "res://weapons/swords/" + drop.item_info[0] + ".png"
		drop.rarity = itemdata[3]
		
		add_child(drop)
