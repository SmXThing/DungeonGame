extends Enemy

func _ready():
	super._ready()  # runs base _ready logic
	speed = 20            # slow
	health = 100          # tanky
	damage = 20           # hits harder
	detection_range = 128.0
	attack_cooldown = 1.5  # attacks less often
