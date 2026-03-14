extends Enemy  # note: inherits the Enemy class

func _ready():
	super._ready()  # runs base _ready
	speed = 60
	health = 25
	damage = 5
	detection_range = 128.0
