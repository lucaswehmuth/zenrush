class_name CircleCasterEnemy
extends BaseEnemy

@export var preferred_distance: float = 400.0
@export var fire_cooldown: float = 3.0
@export var spell_radius: float = 50.0
@export var spell_duration: float = 0.4
@export var spell_damage: float = 20.0
@export var windup_duration: float = 1.5

var _fire_timer: float = 0.0
var _circle: Polygon2D

func _ready() -> void:
	super()
	var screen_size := get_viewport_rect().size
	preferred_distance = min(preferred_distance, screen_size.x / 2.0)
	_circle = Polygon2D.new()
	_circle.polygon = _make_circle_polygon(spell_radius)
	_circle.color = Color.BLACK
	_circle.modulate.a = 0.0
	_circle.visible = false
	add_child(_circle)

func _make_circle_polygon(radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	var steps := 32
	for i in steps:
		var angle := (TAU / steps) * i
		points.append(Vector2.from_angle(angle) * radius)
	return points

func _cast_spell() -> void:
	var target_pos: Vector2 = player.global_position
	remove_child(_circle)
	get_tree().current_scene.add_child(_circle)
	_circle.global_position = target_pos
	_circle.color = Color.BLACK
	_circle.modulate.a = 0.0
	_circle.visible = true
	var tween := create_tween()
	tween.tween_property(_circle, "modulate:a", 0.3, windup_duration)
	await get_tree().create_timer(windup_duration).timeout
	_circle.color = Color(1.0, 0.3, 0.0, 1.0)
	_circle.modulate.a = 1.0
	if player:
		var dist := _circle.global_position.distance_to(player.global_position)
		if dist <= spell_radius:
			player.take_damage(spell_damage)
	var fade_tween := create_tween()
	fade_tween.tween_property(_circle, "modulate:a", 0.0, spell_duration)
	await get_tree().create_timer(spell_duration).timeout
	_circle.visible = false
	add_child(_circle)

func _physics_process(delta: float) -> void:
	_fire_timer -= delta
	if _fire_timer <= 0.0 and player and _can_shoot():
		_cast_spell()
		_fire_timer = fire_cooldown
	super(delta)

func _can_shoot() -> bool:
	var camera = get_viewport().get_camera_2d()
	var screen_rect = get_viewport_rect()
	var local_pos = global_position - camera.global_position
	var half_size = screen_rect.size / 2.0
	return abs(local_pos.x) < half_size.x and abs(local_pos.y) < half_size.y
		
func _move(delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	var direction = (player.global_position - global_position).normalized()
	if distance < preferred_distance:
		velocity = -direction * move_speed
	else:
		velocity = direction * move_speed
