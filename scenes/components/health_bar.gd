class_name HealthBar
extends ProgressBar

@onready var damagebar: ProgressBar = $Damagebar
var tween: Tween

var health = 0.0 : set = _set_health

func _set_health(new_health: float):
	var previous_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health <= previous_health:
		_animate_damagebar()
	else:
		damagebar.value = health

func _animate_damagebar() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(0.1)
	tween.tween_property(damagebar, "value", health, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func init(_health: float):
	max_value = _health
	damagebar.max_value = _health
	health = _health
	value = _health
	damagebar.value = _health

func _on_timer_timeout() -> void:
	damagebar.value = health
