extends Node

'''
Weapon Format - [Name, Description, Damage]
Swords - [Swing Speed Scale, Diagonal Length, Diagonal Width]
Bows - [Arrow Speed Scale, Shoot Speed Scale, Piercing]
Staffs - [Firing Speed Scale, Piercing, AOE]
'''

var default_weapons: Array[Array] = [
	["Wooden_Sword", "A not-so-reliable wooden sword. At least it gets the job done.", 5, 1.0, 14, 3],
	["Mahogany_Bow", "Somewhat worn, but intact enough to shoot enemies.", 3, 1.0, 1.0, 0],
	["Oak_Staff", "A long, wooden stick tipped with a spiral. Casts simple fireballs.", 4, 1.0, 2, 1]
]

var common_swords: Array[Array] = [
	["Stick", "A simple stick. You could hardly call it a weapon.", 1, 2.0, 9, 2],
	["Knife", "Perhaps better suited for a kitchen.", 5, 1.3, 7, 2],
	["Thin_Sword", "A thin, makeshift sword that looks to be made with rebar. It's light at least.", 8, 1.1, 13, 2],
	["Iron_Dagger", "A lightweight dagger made from cast iron.", 7, 1.4, 8, 3],
]

var uncommon_swords: Array[Array] = [
	["Steel_Stabber", "A small blade made with steel. The tip is especially thin, making it good for stabbing.", 8, 1.4, 8, 3],
	["Blood_Dagger", "A compact dagger with a small bloodstone embedded into the guard.", 9, 1.4, 10, 3],
	["Kukri", "A hefty Kukri blade made from steel. Quite heavy.", 12, 0.5, 16, 3],
	["Cane_Sword", "A long, thin blade attached to the end of a cane. It's got some nice reach.", 10, 1.2, 24, 2],
]

var rare_swords: Array[Array] = [
	["Ruby_Dagger", "A shiny red blade. Pretty thin for a dagger.", 11, 1.4, 9, 2],
	["Diamond_Dagger", "A bright, blue, diamond blade. Quite flashy.", 12, 1.5, 9, 3],
	["Diamond_Sword", "A long diamond blade. Looks a little familiar for some reason...", 15, 1.0, 14, 3],
	["Sapphire_Dagger", "A short, dark blue blade. It's reminescent of the night sky.", 13, 1.5, 8, 3],
	["Emerald_Blade", "A hefty emerald blade shimmering with the colors of various gemstones.", 17, 0.8, 17, 4],
	["Pirate_Saber", "A bright blade made from white steel. It's curved tip makes it good for thrusting.", 17, 1.2, 15, 3]
]

var epic_swords: Array[Array] = [
	["Gilded_Sword", "A bright, golden blade decorated with rubies.", 18, 0.9, 15, 4],
	["Dracula_Blade", "A very long blade made of diamond and emerald, characterized by its black guarded with a strange red gem embedded within.", 20, 1.0, 26, 4],
	["Incendium_Blade", "A bride red blade made from a strange, light material. It's edge is exceptionally sharp.", 21, 1.2, 16, 4],
	["Skullbreaker", "An exceptionally large, and heavy sword. Best suited for two hands.", 28, 0.25, 42, 8],
]

var legendary_swords: Array[Array] = [
	["Lunar_Bane", "A beautifully crafted blade with the colors of the night sky.", 30, 1.0, 24, 6],
	["Earthsplitter", "A towering behemoth of a sword. You could probably cut through stone with this thing.", 50, 0.25, 44, 9],
	["Reaper_Falchion", "A pristine purple blade. Despite it's large size, it is quite lightweight.", 34, 1.1, 24, 5],
]

var common_bows: Array[Array] = [
	["Tin_Bow", "A rustic bow made of tin. A bit heavy.", 4, 1.0, 0.8, 0],
	["Steel_Bow", "A bow made of shiny steel. It is heavy, but strong enough to pierce an enemy.", 5, 1.2, 0.8, 1],
	["Bright_Bow", "A large bow made of a foreign material.", 7, 1.4, 0.6, 2],
]

var uncommon_bows: Array[Array] = [
	["Gilded_Bow", "A lightweight bow that shoots fast.", 7, 1.4, 1.4, 1],
	["Night_Bow", "A strange, purple bow.", 9, 1.0, 1.0, 1],
	["Ice_Bow", "A magical bow made from ice that never melts. Very light.", 10, 1.2, 1.5, 1]
]

var rare_bows: Array[Array] = [
	["Reinforced_Amythest_Bow", "An amythest bow reinforced with steel. A bit slow, but arrows fired are quite fast.", 12, 1.3, 0.7, 3],
	["Longbow", "A very large bow made of tough wood. Though it looks unassuming, it's arrows can pierce through any enemy in its path.", 15, 2.2, 0.5, 100],
	["Rugged_Ranger_Bow", "A bow belonging to a past ranger much like yourself. Though it is old, it is still quite effective.", 16, 1.6, 1.4, 4]
]

var epic_bows: Array[Array] = [
	["Inferno_Bow", "A blazing, orange bow. It's quiet hot to wield. It's arrows are hot enough to pierce through all enemies in its path.", 18, 1.4, 1.5, 100],
	["Manta_Bow", "A pristine, blue bow. It's color is reminescent of the ocean.", 19, 1.5, 2.0, 5],
	["Emerald_Splitter", "A shimmering green bow with a complex design. Known for it's ability to shoot extremely fast arrows.", 22, 2.5, 1.0, 8]
]

var legendary_bows: Array[Array] = [
	["Twisted_Root", "A large bow imbued with a strange curse. It can fire arrows very fast, and pierce through all enemies.", 24, 1.2, 10.0, 100]
]

var common_staffs: Array[Array] = [
	["Magic_Wand", "A basic, spellcaster's wand.", 5, 1.0, 4, false],
	["Turquoise_Staff", "A staff tipped with a turquoise gem.", 6, 1.0, 4, false],
	["Ruby_Staff", "A dark-colored staff headed with a ruby gem.", 8, 1.2, 4, false],
	
]

var uncommon_staffs: Array[Array] = [
	["Bejeweled_Staff", "A strange looking staff decorated with various jewels.", 11, 1.4, 6, false],
	["Sapphire_Staff", "A long, staff with a curved ahndle.", 13, 1.2, 0, true]
]

var rare_staffs: Array[Array] = [
	["Emperor_Staff", "A large, regal-looking staff. It is quite heavy.", 15, 1.0, 2, true],
	["Oceanic_Fork", "A strange, fork-shaped wand that shoots water-like projectiles.", 16, 3.0, 4, false],
	["Amythest_Caster", "A heavy wand with a complex design.", 18, 1.4, 2, true]
]

var epic_staffs: Array[Array] = [
	["Crystal_Staff", "A large staff with a blue crystal ball. Its projectiles explode and deal good damage.", 28, 1.0, 0, true],
	["Empirical_Staff", "A light staff reinforced with iron. It can fire quickly and pierce through any enemy.", 20, 2.5, 100, false]
]

var legendary_staffs: Array[Array] = [
	["Jade_Caster", "A large, enchanted jade staff that shoots large, exploding projectiles.", 30, 1.5, 0, true],
	["Cosmic_Emitter", "A pristine staff with an iridescent crystal ball at its head.", 36, 1.2, 1, true]
]

var swords: Dictionary[String, Array] = {
	"Common": common_swords,
	"Uncommon": uncommon_swords,
	"Rare": rare_swords,
	"Epic": epic_swords,
	"Legendary": legendary_swords
}

var bows: Dictionary[String, Array] = {
	"Common": common_bows,
	"Uncommon": uncommon_bows,
	"Rare": rare_bows,
	"Epic": epic_bows,
	"Legendary": legendary_bows
}

var staffs: Dictionary[String, Array] = {
	"Common": common_staffs,
	"Uncommon": uncommon_staffs,
	"Rare": rare_staffs,
	"Epic": epic_staffs,
	"Legendary": legendary_staffs
}

var weapons: Dictionary[String, Dictionary] = {
	"sword": swords,
	"bow": bows,
	"staff": staffs
}

func compile_weapon(weapon_type: String, weapon_info: Array, rarity: String) -> Weapon:
	if weapon_type == "sword":
		var sword: Sword = Sword.new()
		
		sword.item_name = weapon_info[0]
		sword.item_description = weapon_info[1]
		sword.sprite = Sprite2D.new()
		sword.sprite.texture = load("res://weapons/swords/" + sword.item_name + ".png")
		sword.add_child(sword.sprite)
		sword.rarity = rarity
		sword.damage = weapon_info[2]
		sword.attack_speed_scale = weapon_info[3]
		sword.diagonal_range = weapon_info[4]
		sword.diagonal_width = weapon_info[5]
		return sword
	elif weapon_type == "bow":
		var bow: Bow = Bow.new()
		bow.item_name = weapon_info[0]
		bow.item_description = weapon_info[1]
		bow.sprite.texture = load("res://weapons/bows/" + bow.item_name + ".png")
		bow.rarity = rarity
		bow.damage = weapon_info[2]
		bow.arrow_speed_scale = weapon_info[3]
		bow.shoot_speed_scale = weapon_info[4]
		bow.piercing = weapon_info[5]
		return bow
	elif weapon_type == "staff":
		var staff: Staff = Staff.new()
		staff.item_name = weapon_info[0]
		staff.item_description = weapon_info[1]
		staff.sprite.texture = load("res://weapons/staffs/" + staff.item_name + ".png")
		staff.rarity = rarity
		staff.damage = weapon_info[2]
		staff.fire_speed_scale = weapon_info[3]
		staff.piercing = weapon_info[4]
		staff.AOE = weapon_info[5]
		return staff
	else:
		return null

func generate_random_weapon(weapon_type: String) -> Weapon:
	'''
	Rarity %
	- Common: 35%
	- Uncommon: 30%
	- Rare: 23%
	- Epic: 9%
	- Legendary: 3%
	'''
	
	var rand_int: int = randi_range(1, 100)
	var rarity: String
	var possible_weapons: Array[Array]
	var weapon_info: Array
	
	if rand_int > 0 && rand_int <= 35:
		rarity = "Common"
	elif rand_int > 35 && rand_int <= 65:
		rarity = "Uncommon"
	elif rand_int > 65 && rand_int <= 88:
		rarity = "Rare"
	elif rand_int > 88 && rand_int <= 97:
		rarity = "Epic"
	else:
		rarity = "Legendary"
	
	possible_weapons = weapons[weapon_type][rarity]
	weapon_info = possible_weapons[randi_range(0, len(possible_weapons) - 1)]
	
	return compile_weapon(weapon_type, weapon_info, rarity)
