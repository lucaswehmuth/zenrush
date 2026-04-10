class_name SummonerEnemy
extends BaseEnemy

@export var minion_scene: PackedScene
@export var max_minions: int = 3
@export var spawn_cooldown: float = 3.0
@export var preferred_distance: float = 300.0

var _spawn_timer: float = 0.0
var _active_minions: Array[Node] = []

func _physics_process(delta: float) -> void:
	_spawn_timer -= delta
	_active_minions = _active_minions.filter(func(m): return is_instance_valid(m))
	if _spawn_timer <= 0.0 and _active_minions.size() < max_minions:
		_spawn_minion()
		_spawn_timer = spawn_cooldown
	super(delta)

func _move(delta: float) -> void:
	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()
	var direction: Vector2 = to_player.normalized()
	if distance < preferred_distance:
		velocity = -direction * move_speed
	else:
		velocity = direction * move_speed

func _spawn_minion() -> void:
	if not minion_scene:
		return
	var minion = minion_scene.instantiate()
	var offset := Vector2.from_angle(randf() * TAU) * 40.0
	minion.global_position = global_position + offset
	minion.override_color = sprite_2d.modulate
	get_tree().current_scene.add_child.call_deferred(minion)
	_active_minions.append(minion)
	
