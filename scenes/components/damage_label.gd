class_name DamageLabel
extends Label

@export var float_distance: float = 200.0
@export var float_duration: float = 1.3
@export var fade_duration: float = 0.8
@export var offset_above: float = 100.0

func spawn(amount: float) -> void:
	text = str(int(amount))
	await get_tree().process_frame
	position = Vector2(-size.x / 2.0, -offset_above)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -float_distance), float_duration)
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(queue_free).set_delay(float_duration)
