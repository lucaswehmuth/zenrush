class_name Player extends CharacterBody2D

var input_vector = Vector2.ZERO

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var healthbar: HealthBar = $Healthbar
@onready var camera_2d: Camera2D = $Camera2D
@onready var muzzle_flash: CPUParticles2D = $MuzzleFlash
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var completion_bonus_multiplier: float = 1.5
@export var max_health: float = 1000.0
@export var health_regen: float = 0.0
@export var move_speed: float = 300.0
@export var projectile_scene: PackedScene
@export var attack_range_percent: float = 0.9
@export var attack_cooldown: float = 0.5
@export var attack_explosion_radius: float = 0.0
@export var attack_explosion_damage_multiplier: float = 0.2
@export var base_attack_cooldown: float = 0.5
@export var base_damage: float = 10.0
@export var vampirism: float = 0.0

var burst_count: int = 1
var extra_shots: int = 0
var attack_timer: float = 0.0
var current_health: float
var is_dead: bool = false
var shards : int = 0
var shard_magnet: bool = false
@export var projectile_upgrades: Array[BaseProjectileUpgrade] = []
@export var player_upgrades: Array[BasePlayerUpgrade] = []

signal died

func _ready() -> void:
	#get_tree().get_root().print_tree_pretty()
	current_health = max_health
	healthbar.init(max_health)
	hurtbox.hurt.connect(_on_hurt)
	for upgrade in player_upgrades:
		upgrade.apply(self)
		
func apply_meta_stats(stats: Dictionary) -> void:
	for key in stats.keys():
		if key in self:
			set(key, get(key) + stats[key])
		else:
			push_warning("apply_meta_stats: unknown key '%s'" % key)
	current_health = max_health
	healthbar.init(max_health)
	_debug_print_stats()

func _debug_print_stats() -> void:
	print("=== PLAYER META STATS ===")
	print("max_health: ", max_health)
	print("health_regen: ", health_regen)
	print("vampirism: ", vampirism)
	print("move_speed: ", move_speed)
	print("base_damage: ", base_damage)
	print("attack_cooldown: ", attack_cooldown)
	print("attack_range_percent: ", attack_range_percent)
	print("explosion_radius: ", attack_explosion_radius)
	print("explosion_damage_multiplier: ", attack_explosion_damage_multiplier)
	print("=========================")
	
func _draw():
	draw_circle(Vector2.ZERO, _get_dynamic_range(), Color(0, 0, 0, 0.05))
	
func _get_screen_size_world() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var zoom = camera_2d.zoom
	return viewport_size * zoom
	
func _get_camera_rect() -> Rect2:
	var viewport_size = get_viewport_rect().size
	var size = viewport_size * $Camera2D.zoom
	var top_left = global_position - size * 0.5
	return Rect2(top_left, size)
	
func _on_hurt(hitbox: Hitbox) -> void:
	var attacker = hitbox.get_parent()
	if attacker is BaseEnemy or attacker.get_parent() is BaseEnemy:
		take_damage(attacker.damage)
	
	if attacker is BaseProjectile and attacker.shooter == "enemy":
		take_damage(attacker.damage)
		attacker.queue_free()

func take_damage(amount: float) -> void:
	if is_dead:
		return
	current_health -= amount
	healthbar.health = current_health
	print(self, "Took damage - health:", current_health)
	if current_health <= 0.0:
		die()
		
func die() -> void:
	is_dead = true
	print("Player died")
	set_physics_process(false)
	hide()
	died.emit()

func _physics_process(delta: float) -> void:
	queue_redraw()
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * move_speed
	attack_timer -= delta
	if attack_timer <= 0.0:
		var target = _get_nearest_enemy()
		if target:
			_shoot(target)
			attack_timer = attack_cooldown
	move_and_slide()
	if health_regen > 0.0 and current_health < max_health:
		current_health = minf(current_health + health_regen * delta, max_health)
		healthbar.health = current_health

func _shoot(target: BaseEnemy) -> void:
	for i in burst_count:
		if i == 0:
			_fire_projectile(target)
		else:
			await get_tree().create_timer(0.1 * i).timeout
			if is_instance_valid(target):
				_fire_projectile(target)

func _fire_projectile(target: BaseEnemy) -> void:
	if not projectile_scene:
		return
	var base_direction = (target.global_position - global_position).normalized()

	# center shot
	_spawn_projectile(base_direction)

	# extra shots spread around center
	for i in extra_shots:
		var angle_offset = deg_to_rad(15.0 * (i + 1))
		_spawn_projectile(base_direction.rotated(angle_offset))
		_spawn_projectile(base_direction.rotated(-angle_offset))
		
func _spawn_projectile(direction: Vector2) -> void:
	var projectile = projectile_scene.instantiate()
	projectile.shooter = "player"
	get_tree().current_scene.add_child(projectile)
	projectile.init(global_position, direction)
	
	if attack_explosion_radius > 0:
		projectile.explodes = true
		projectile.explosion_radius = attack_explosion_radius
		projectile.explosion_damage_multiplier = attack_explosion_damage_multiplier
		
	for upgrade in projectile_upgrades:
		upgrade.apply(projectile, self)
		
	_trigger_muzzle_flash(global_position, direction)

func _trigger_muzzle_flash(spawn_position: Vector2, direction: Vector2) -> void:
	var half_size = sprite_2d.texture.get_size() * sprite_2d.scale / 2.0
	var offset = direction * max(half_size.x, half_size.y)
	muzzle_flash.global_position = spawn_position + offset
	muzzle_flash.rotation = direction.angle()
	muzzle_flash.restart()
	
func _get_dynamic_range() -> float:
	var screen_size = _get_screen_size_world()
	
	# use diagonal or smaller axis (both are valid approaches)
	var radius = min(screen_size.x, screen_size.y) * 0.5
	
	return radius * attack_range_percent
	
func _get_nearest_enemy() -> BaseEnemy:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest: BaseEnemy = null
	var nearest_dist = _get_dynamic_range()
	var camera_rect = _get_camera_rect()

	for enemy in enemies:
		# 🚫 HARD FILTER: must be on screen
		if not camera_rect.has_point(enemy.global_position):
			continue

		var dist = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
				
	return nearest
