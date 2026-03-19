class_name BaseProjectile
extends Area2D

@export var speed: float = 400.0
@export var damage: float = 10.0
#@export var max_lifetime: float = 3.0

var direction: Vector2 = Vector2.ZERO
var lifetime: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	#lifetime += delta
	#if lifetime >= max_lifetime:
		#queue_free()

func init(spawn_position: Vector2, target_direction: Vector2) -> void:
	global_position = spawn_position
	direction = target_direction.normalized()

func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		body.take_damage(damage)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
