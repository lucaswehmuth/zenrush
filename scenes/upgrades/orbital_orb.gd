class_name OrbitalOrb
extends Area2D

@export var orbit_radius: float = 80.0
@export var orbit_speed: float = 4.0
@export var damage: float = 100.0
@export var damage_cooldown: float = 0.5

var angle: float = 0.0
var player: Player
var hit_timers: Dictionary = {}

func setup(p: Player, starting_angle: float) -> void:
	player = p
	angle = starting_angle
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	angle += orbit_speed * delta
	global_position = player.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius
	
	for enemy in hit_timers.keys():
		hit_timers[enemy] -= delta
		if hit_timers[enemy] <= 0.0:
			hit_timers.erase(enemy)

func _on_area_entered(area: Area2D) -> void:
	if area is not Hurtbox:
		return
	var enemy = area.get_parent()
	if enemy is not BaseEnemy:
		return
	if enemy in hit_timers:
		return
	enemy.take_damage(damage)
	hit_timers[enemy] = damage_cooldown
	print("Orb hit: ", enemy, " for ", damage, " damage. Enemy health: ", enemy.current_health)
