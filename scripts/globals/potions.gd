extends Node

'''
Modifiers: None, Greater, Super

Potion Format:
	Status, Amount, Duration (Seconds)
'''

var potions: Array[Array] = [
	["Health", 5],
	["Strength", 5, 30],
	["Speed", 5, 30],
	["Endurance", 5, 60],
]

func compile_potion(potion_info: Array, modifier: String) -> Potion:
	var potion = Potion.new()
	
	potion.modifier = modifier
	potion.type = potion_info[0]
	potion.mod = potion_info[1]
	potion.duration = potion_info[2]
	
	potion.item_name = potion.type + " Potion"
	potion.item_description = "Boosts " + potion.type + " by " + str(potion.mod)
	
	potion.sprite = Sprite2D.new()
	potion.sprite.texture = load(potion_info[3])
	potion.add_child(potion.sprite)
	
	return potion

func generate_random_potion() -> Array:
	'''
	Modifier Chances:
		None: 75%
		Greater: 20%
		Super: 5%
	'''
	var rand_num: int = randi_range(1, 100)
	
	var modifier: String
	var potion_type: String = potions[randi_range(0, len(potions) - 1)][0]
	var mod: int = potions[randi_range(0, len(potions) - 1)][1]
	var duration: int
	var sprite_path: String = "res://potions/"
	
	var potion_index: int = randi_range(0, len(potions) - 1)
	
	if len(potions[potion_index]) > 2:
		duration = potions[potion_index][2]
	
	if rand_num > 0 && rand_num <= 75:
		modifier = "None"
		sprite_path += potion_type + "Potion.png"
	elif rand_num > 75 && rand_num <= 95:
		modifier = "Greater"
		mod = round(mod * 1.5)
		if duration:
			duration = round(duration * 1.5)
		sprite_path += modifier + potion_type + "Potion.png"
	else:
		modifier = "Super"
		mod = mod * 2
		if duration:
			duration = duration * 2
		sprite_path += modifier + potion_type + "Potion.png"
	
	return ["Potion", [potion_type, mod, duration, sprite_path], modifier]
