class_name Shard
extends Area2D

@export var attraction_speed: float = 400.0
@export var scatter_radius_min: float = 8.0
@export var scatter_radius_max: float = 20.0
@export var scatter_duration: float = 0.4

var _player: Node2D
var value: int = 1
var _attract_on_ready: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_player = get_tree().get_first_node_in_group("player")
	set_physics_process(false)
	_spawn_animation()
	if _attract_on_ready:
		attract()

func _spawn_animation() -> void:
	var angle = randf_range(0.0, TAU)
	var radius = randf_range(scatter_radius_min, scatter_radius_max)
	var target_pos = global_position + Vector2(cos(angle), sin(angle)) * radius

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, scatter_duration) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func attract() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_player):
		return
	var to_player = _player.global_position - global_position
	global_position += to_player.normalized() * attraction_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.shards += value
		queue_free()
