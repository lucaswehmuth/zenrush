class_name SpawnManager
extends Node2D

@export var tank_scene: PackedScene
@export var ranged_scene: PackedScene

var current_enemy: BaseEnemy = null

func _ready() -> void:
	_spawn_enemy()

func _spawn_enemy() -> void:
	var scene = [tank_scene, ranged_scene].pick_random()
	current_enemy = scene.instantiate()
	current_enemy.global_position = _get_spawn_position()
	current_enemy.died.connect(_on_enemy_died)
	add_child(current_enemy)

func _on_enemy_died(enemy: BaseEnemy) -> void:
	_spawn_enemy()

func _get_spawn_position() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	var center = camera.global_position
	var half_w = get_viewport_rect().size.x / 2.0
	var half_h = get_viewport_rect().size.y / 2.0
	return center + Vector2(
		randf_range(-half_w * 0.8, half_w * 0.8),
		randf_range(-half_h * 0.8, half_h * 0.8)
	)
