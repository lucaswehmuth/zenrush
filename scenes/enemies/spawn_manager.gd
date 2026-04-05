class_name SpawnManager
extends Node2D

signal upgrade_available

@onready var timer_label: Label = $"../CanvasLayer/TimerLabel"

@export var base_enemy_scene: PackedScene
@export var rusher_scene: PackedScene
@export var ranged_scene: PackedScene
@export var tank_scene: PackedScene

## Total game run time in seconds - 10 minutes
const RUN_DURATION: float = 600.0  

## Minimum distance from the player at which enemies are allowed to spawn. 
const SAFE_RADIUS: float = 150.0 

var elapsed_time: float = 0.0
var next_upgrade_time: float = 0.0
var difficulty: float = 0.0
var active_enemies: Array[BaseEnemy] = []
var spawn_timer: float = 0.0
var run_active: bool = false
var enemies_killed: int = 0


func _ready() -> void:
	start_run()

func start_run() -> void:
	elapsed_time = 0.0
	difficulty = 0.0
	run_active = true
	_spawn_enemy()

func _process(delta: float) -> void:
	if not run_active:
		return

	elapsed_time += delta
	difficulty = elapsed_time / RUN_DURATION
	_update_timer_label()

	if elapsed_time >= next_upgrade_time:
		next_upgrade_time += 60.0
		print("upgrade_available emitted")
		upgrade_available.emit()
		return
		
	if elapsed_time >= RUN_DURATION:
		stop_run()
		return

	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn_enemy()
		spawn_timer = _get_spawn_interval()

func _update_timer_label() -> void:
	var remaining = RUN_DURATION - elapsed_time
	var minutes = int(remaining / 60.0)
	var seconds = int(fmod(remaining, 60.0))
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func _get_spawn_interval() -> float:
	# starts at 3s, bottoms out at 0.5s at full difficulty
	return lerp(1.0, 0.5, difficulty)

func _get_max_enemies() -> int:
	# starts at 3, caps at 20 at full difficulty
	return int(lerp(3.0, 20.0, difficulty))

func _spawn_enemy() -> void:
	if active_enemies.size() >= _get_max_enemies():
		return

	var scene = _pick_enemy_scene()
	var enemy: BaseEnemy = scene.instantiate()
	enemy.global_position = _get_spawn_position()
	enemy.died.connect(_on_enemy_died)
	add_child(enemy)
	active_enemies.append(enemy)

func _pick_enemy_scene() -> PackedScene:
	if difficulty < 0.33:
		# early — mostly base, some rushers, few ranged
		return _weighted_pick([
			[base_enemy_scene, 0.60],
			[rusher_scene,     0.25],
			[ranged_scene,     0.15],
			[tank_scene,       0.00],
			#[base_enemy_scene, 0.10],
			#[rusher_scene,     0.10],
			#[ranged_scene,     0.80],
			#[tank_scene,       0.00],
		])
	elif difficulty < 0.66:
		# mid — same but tanks start appearing
		return _weighted_pick([
			[base_enemy_scene, 0.40],
			[rusher_scene,     0.25],
			[ranged_scene,     0.25],
			[tank_scene,       0.10],
		])
	else:
		# late — less base, more ranged, more tanks
		return _weighted_pick([
			[base_enemy_scene, 0.15],
			[rusher_scene,     0.25],
			[ranged_scene,     0.50],
			[tank_scene,       0.10],
		])

func _weighted_pick(entries: Array) -> PackedScene:
	var roll = randf()
	var cumulative = 0.0
	for entry in entries:
		cumulative += entry[1]
		if roll < cumulative:
			return entry[0]
	return entries[-1][0]

func _on_enemy_died(enemy: BaseEnemy) -> void:
	active_enemies.erase(enemy)
	enemies_killed += 1

func _get_spawn_position() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	var center = camera.global_position
	var half_w = get_viewport_rect().size.x / 2.0
	var half_h = get_viewport_rect().size.y / 2.0
	var player = get_tree().get_first_node_in_group("player")
	var player_pos = player.global_position if player else center

	var angle = randf_range(0, TAU)
	var radius = randf_range(SAFE_RADIUS, SAFE_RADIUS * 2.0)
	var pos = player_pos + Vector2(cos(angle), sin(angle)) * radius

	pos.x = clamp(pos.x, center.x - half_w * 0.8, center.x + half_w * 0.8)
	pos.y = clamp(pos.y, center.y - half_h * 0.8, center.y + half_h * 0.8)

	return pos

func stop_run() -> void:
	run_active = false
	for enemy in active_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	active_enemies.clear()
	print("Run complete - elapsed: ", elapsed_time)
