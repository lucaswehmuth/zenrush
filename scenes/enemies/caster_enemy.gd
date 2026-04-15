class_name CasterEnemy
extends BaseEnemy

@export var cast_spell_scene: PackedScene
@export var preferred_distance: float = 200.0
@export var fire_cooldown: float = 3.0
@export var spell_width: float = 400.0
@export var spell_height: float = 1600.0
@export var spell_duration: float = 0.4
@export var spell_damage: float = 100.0
@export var trigger_range: float = 300.0
@export var windup_duration: float = 0.8

var offset: float = 80.0
var _fire_timer: float = 0.0
var _spell_area: Area2D
var _spell_visual: ColorRect

var _beam: Line2D

func _ready() -> void:
	super()
	_beam = Line2D.new()
	_beam.width = spell_width
	_beam.default_color = Color(1.0, 0.3, 0.0, 1.0)
	_beam.visible = false
	add_child(_beam)
	
func _cast_spell() -> void:
	var locked_rotation: float = (player.global_position - global_position).angle() + PI / 2.0
	_beam.clear_points()
	_beam.add_point(Vector2(0, -offset))
	_beam.add_point(Vector2(0, -(spell_height + offset)))
	_beam.rotation = locked_rotation
	_beam.default_color = Color.BLACK
	_beam.modulate.a = 0.0
	_beam.visible = true
	var tween := create_tween()
	tween.tween_property(_beam, "modulate:a", 0.3, windup_duration)
	await get_tree().create_timer(windup_duration).timeout
	# fire
	_beam.default_color = Color(1.0, 0.3, 0.0, 1.0)
	_beam.modulate.a = 1.0
	if player:
		var dist := global_position.distance_to(player.global_position)
		if dist <= spell_height:
			player.take_damage(spell_damage)
	var fade_tween := create_tween()
	fade_tween.tween_property(_beam, "modulate:a", 0.0, spell_duration)
	await get_tree().create_timer(spell_duration).timeout
	_beam.visible = false

func _physics_process(delta: float) -> void:
	_fire_timer -= delta
	if _fire_timer <= 0.0 and player:
		_cast_spell()
		_fire_timer = fire_cooldown
	super(delta)

func _deal_damage() -> void:
	for body in _spell_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(spell_damage)

func _move(delta: float) -> void:
	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()
	var direction: Vector2 = to_player.normalized()
	if distance < preferred_distance:
		velocity = -direction * move_speed
	else:
		velocity = direction * move_speed
