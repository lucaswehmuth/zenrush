class_name BaseProjectile
extends Area2D

@export var speed: float = 400.0
@export var damage: float = 10.0
@export var knockback_amount: float = 0.0

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func init(spawn_position: Vector2, target_direction: Vector2) -> void:
	global_position = spawn_position
	direction = target_direction.normalized()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
