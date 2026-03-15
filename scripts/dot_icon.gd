extends Sprite2D

@export var color: Color = Color(1, 1, 1, 1)
@export var pulse_scale: float = 1
@export var pulse: Sprite2D
@export var pulse_timer: Timer
@export var frequency: float = 1.0

var max_pulse_size: float

func _ready() -> void:
	max_pulse_size = pulse.scale.x * pulse_scale
	pulse.scale = Vector2(0,0)
	pulse_timer.wait_time = frequency
	modulate = color
	pulse_effect()
	pulse_timer.start()

func pulse_effect() -> void:
	pulse.scale.x = 0
	pulse.scale.y = 0
	pulse.modulate = Color(1, 1, 1, 1)
	
	var pulse_tween_x: Tween = create_tween()
	pulse_tween_x.tween_property(pulse, "scale:x", max_pulse_size, frequency).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var pulse_tween_y: Tween = create_tween()
	pulse_tween_y.tween_property(pulse, "scale:y", max_pulse_size, frequency).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(pulse, "modulate", Color(1, 1, 1, 0), frequency)
	

func _on_pulse_timeout() -> void:
	pulse_effect()
	pulse_timer.start()
