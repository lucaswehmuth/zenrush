class_name BlasterEnemy
extends BaseEnemy

@onready var _hurtbox_shape: CollisionShape2D = $Hurtbox/CollisionShape2D

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 120.0
@export var fire_cooldown: float = 2.5
@export var preferred_distance: float = 280.0
@export var shot_count: int = 8

var _fire_timer: float = 0.0
var _spawn_offset: float = 0.0

func _ready() -> void:
	super()
	var shape = _hurtbox_shape.shape
	if shape is CircleShape2D:
		_spawn_offset = shape.radius / 2.0
	elif shape is RectangleShape2D:
		_spawn_offset = shape.size.length() / 2.0

func _physics_process(delta: float) -> void:
	_fire_timer -= delta
	if _fire_timer <= 0.0 and player and _is_on_screen():
		_shoot()
		_fire_timer = fire_cooldown
	super(delta)

func _move(delta: float) -> void:
	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()
	var direction: Vector2 = to_player.normalized()
	if distance < preferred_distance:
		velocity = -direction * move_speed
	else:
		velocity = direction * move_speed

func _shoot() -> void:
	if not projectile_scene:
		return
	var angle_to_player: float = (player.global_position - global_position).angle()
	for i in shot_count:
		var angle: float = angle_to_player + (TAU / shot_count) * i
		var direction: Vector2 = Vector2.from_angle(angle)
		var projectile = projectile_scene.instantiate()
		projectile.shooter = "enemy"
		get_tree().root.add_child(projectile)
		projectile.init(global_position + direction * _spawn_offset, direction, projectile_speed, Color.HOT_PINK)

func _is_on_screen() -> bool:
	var camera = get_viewport().get_camera_2d()
	var screen_rect = get_viewport_rect()
	var local_pos = global_position - camera.global_position
	var half_size = screen_rect.size / 2.0
	return abs(local_pos.x) < half_size.x and abs(local_pos.y) < half_size.y
