class_name BaseProjectile
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var speed: float = 400.0
@export var damage: float = 10.0
@export var knockback_amount: float = 0.0

var pierce_count: int = 0
var shooter: String = ""

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func init(spawn_position: Vector2, target_direction: Vector2, projectile_speed: float = 400.0, color: Color = Color.WHITE) -> void:
	global_position = spawn_position
	direction = target_direction.normalized()
	speed = projectile_speed
	sprite_2d.modulate = color

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
