class_name HealerCasterEnemy
extends BaseEnemy

@onready var heal_area: Area2D = $HealArea
@onready var heal_shape: CollisionShape2D = $HealArea/CollisionShape2D

@export var preferred_distance: float = 50.0
@export var fire_cooldown: float = 5.0
@export var heal_radius: float = 400.0
@export var heal_amount: float = 10.0
@export var windup_duration: float = 3.0
@export var spell_duration: float = 0.5

var _closest_enemy: BaseEnemy = null
var _fire_timer: float = 0.0
var _circle: Polygon2D

func _ready() -> void:
	super()
	(heal_shape.shape as CircleShape2D).radius = heal_radius
	_find_closest_enemy()
	_circle = Polygon2D.new()
	_circle.polygon = _make_circle_polygon(heal_radius)
	_circle.color = Color.BLACK
	_circle.modulate.a = 0.0
	_circle.visible = false
	add_child(_circle)

func _find_closest_enemy() -> void:
	var closest_dist := INF
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy == self:
			continue
		var dist := global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			_closest_enemy = enemy
	if _closest_enemy:
		_closest_enemy.died.connect(_on_closest_died)

func _on_closest_died(_enemy: BaseEnemy) -> void:
	_closest_enemy = null
	_find_closest_enemy()
	
func _make_circle_polygon(radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	var steps := 32
	for i in steps:
		var angle := (TAU / steps) * i
		points.append(Vector2.from_angle(angle) * radius)
	return points

func _cast_spell() -> void:
	_circle.color = Color.BLACK
	_circle.modulate.a = 0.0
	_circle.visible = true
	var tween := create_tween()
	tween.tween_property(_circle, "modulate:a", 0.3, windup_duration)
	await get_tree().create_timer(windup_duration).timeout
	_circle.color = Color(0.0, 0.8, 0.3, 0.7)
	_circle.modulate.a = 1.0
	_heal_nearby_enemies()
	var fade_tween := create_tween()
	fade_tween.tween_property(_circle, "modulate:a", 0.0, spell_duration)
	await get_tree().create_timer(spell_duration).timeout
	_circle.visible = false

func _heal_nearby_enemies() -> void:
	for area in heal_area.get_overlapping_areas():
		var parent := area.get_parent()
		if parent == self:
			continue
		if parent.is_in_group("enemy"):
			parent.take_damage(-heal_amount)

func _physics_process(delta: float) -> void:
	_fire_timer -= delta
	if _fire_timer <= 0.0 and player:
		_cast_spell()
		_fire_timer = fire_cooldown
	super(delta)

func _move(delta: float) -> void:
	if not _closest_enemy:
		return
	var to_closest := _closest_enemy.global_position - global_position
	var direction := to_closest.normalized()
	if to_closest.length() < preferred_distance:
		velocity = -direction * move_speed
	else:
		velocity = direction * move_speed
