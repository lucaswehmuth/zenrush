class_name RangedEnemy
extends BaseEnemy

@onready var _hurtbox_shape: CollisionShape2D = $Hurtbox/CollisionShape2D
var _projectile_spawn_offset: float = 0.0

@export var min_range: float = 200.0
@export var max_range: float = 350.0
@export var projectile_speed: float = 100.0
@export var fire_cooldown: float = 0.5
@export var projectile_scene: PackedScene

var fire_timer: float = 0.0

func _ready() -> void:
	max_health = 60.0
	move_speed = 60.0
	damage = 8.0
	shard_value = 2
	_cache_spawn_offset()
	super()
	
func _cache_spawn_offset() -> void:
	var shape = _hurtbox_shape.shape
	if shape is CircleShape2D:
		_projectile_spawn_offset = shape.radius
	elif shape is RectangleShape2D:
		_projectile_spawn_offset = shape.size.length() / 2.0

func _physics_process(delta: float) -> void:
	fire_timer -= delta
	if fire_timer <= 0.0 and player:
		_shoot()
		fire_timer = fire_cooldown
	
	super(delta)

func _move(delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	var direction = (player.global_position - global_position).normalized()

	if distance < min_range:
		velocity = -direction * move_speed
	elif distance > max_range:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO

func _shoot() -> void:
	if not projectile_scene:
		return
	var projectile = projectile_scene.instantiate()
	projectile.shooter = "enemy"
	get_tree().root.add_child(projectile)
	var direction = (player.global_position - global_position).normalized()
	projectile.init(global_position + direction * _projectile_spawn_offset, direction, projectile_speed, Color.HOT_PINK)
