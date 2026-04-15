class_name OrbEnemy
extends BaseEnemy

@export var orbit_radius: float = 300.0
@export var orbit_speed: float = 2.0
@export var orb_count: int = 5
@export var orb_damage: float = 50.0
@export var orb_damage_cooldown: float = 0.5

var _orbs: Array[Area2D] = []
var _angle: float = 0.0
var _hit_timers: Dictionary = {}

func _ready() -> void:
	super()
	for i in orb_count:
		var orb := Area2D.new()
		var shape := CollisionShape2D.new()
		var circle := CircleShape2D.new()
		circle.radius = 8.0
		shape.shape = circle
		orb.add_child(shape)
		var visual := ColorRect.new()
		visual.size = Vector2(16.0, 16.0)
		visual.position = Vector2(-8.0, -8.0)
		visual.color = sprite_2d.modulate
		orb.add_child(visual)
		orb.area_entered.connect(_on_orb_area_entered)
		get_tree().current_scene.add_child.call_deferred(orb)
		_orbs.append(orb)

func _physics_process(delta: float) -> void:
	_angle += orbit_speed * delta
	for i in _orbs.size():
		var offset_angle := _angle + (TAU / _orbs.size()) * i
		_orbs[i].global_position = global_position + Vector2(cos(offset_angle), sin(offset_angle)) * orbit_radius
	for key in _hit_timers.keys():
		_hit_timers[key] -= delta
		if _hit_timers[key] <= 0.0:
			_hit_timers.erase(key)
	super(delta)

func _on_orb_area_entered(area: Area2D) -> void:
	if area is not Hurtbox:
		return
	var body := area.get_parent()
	if not body.is_in_group("player"):
		return
	if body in _hit_timers:
		return
	body.take_damage(orb_damage)
	_hit_timers[body] = orb_damage_cooldown

func _move(delta: float) -> void:
	var direction := (player.global_position - global_position).normalized()
	velocity = direction * move_speed

func die() -> void:
	for orb in _orbs:
		if is_instance_valid(orb):
			orb.queue_free()
	super()
