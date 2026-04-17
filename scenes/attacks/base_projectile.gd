class_name BaseProjectile
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var explosion_scene: PackedScene
@export var speed: float = 400.0
@export var damage: float = 10.0
@export var knockback_amount: float = 0.0
@export var stun_on_hit: bool = true
@export var stun_duration: float = 0.05

var explodes: bool = false
var explosion_radius: float = 0.0
var explosion_damage_multiplier: float = 0.25
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

func _explode() -> void:
	var explosion = explosion_scene.instantiate()
	var pos = global_position  # cache before anything else
	get_tree().root.add_child(explosion)
	explosion.global_position = pos
	explosion.damage = damage * explosion_damage_multiplier
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
