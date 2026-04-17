class_name BaseEnemy
extends CharacterBody2D

signal died(enemy: BaseEnemy)

const DAMAGE_LABEL = preload("uid://d2oi4h4yx7wvd")

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_bar: HealthBar = $HealthBar
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var max_health: float = 100.0
@export var move_speed: float = 80.0
@export var damage: float = 10.0
@export var shard_value: int = 1
@export var shard_scene: PackedScene

@export var show_hit_flash: bool = true
@export var show_health_bar: bool = false
@export var show_damage_numbers: bool = true

var current_health: float
var player: Node2D
var original_color: Color
var override_color: Color

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("player")
	hurtbox.hurt.connect(_on_hurt)
	health_bar.init(max_health)
	health_bar.visible = show_health_bar
	if override_color:
		sprite_2d.modulate = override_color
	original_color = sprite_2d.modulate

func _physics_process(delta: float) -> void:
	if player:
		_move(delta)
	move_and_slide()

# Override this in each variant
func _move(delta: float) -> void:
	# TODO - remove later
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * move_speed
	
func _on_hurt(hitbox: Hitbox) -> void:
	var attacker = hitbox.get_parent()
	if attacker is BaseProjectile and attacker.shooter == "player":
		take_damage(attacker.damage, attacker.stun_on_hit, attacker.stun_duration)
		if attacker.explodes:
			attacker._explode()
		if attacker.pierce_count <= 0:
			attacker.queue_free()
		else:
			attacker.pierce_count -= 1

func take_damage(amount: float, stun: bool = false, stun_duration: float = 0.0) -> void:
	current_health = min(current_health - amount, max_health)
	if show_health_bar:
		health_bar.health = current_health
	if show_damage_numbers:
		_spawn_damage_label(amount)
	if show_hit_flash:
		_flash()
	if stun:
		_stun(stun_duration)
	if current_health <= 0.0:
		die()

func _spawn_damage_label(amount: float) -> void:
	var label := DAMAGE_LABEL.instantiate() as DamageLabel
	add_child(label)
	var color := Color.WHITE if amount > 0 else Color.LIME_GREEN
	label.position = Vector2(0, -40)
	label.spawn(amount, color)
	
func _flash() -> void:
	var tween := create_tween()
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.05)
	tween.tween_property(sprite_2d, "modulate", original_color, 0.1)
	
func _stun(duration: float) -> void:
	set_physics_process(false)
	await get_tree().create_timer(duration).timeout
	set_physics_process(true)
	
func die() -> void:
	if shard_scene:
		var shard = shard_scene.instantiate()
		shard.value = shard_value
		shard.global_position = global_position
		if player and player.shard_magnet:
			shard._attract_on_ready = true
		get_tree().current_scene.add_child.call_deferred(shard)
		
	if player and player.vampirism > 0.0:
		player.current_health = min(player.max_health, player.current_health + player.vampirism)
		player.healthbar.health = player.current_health
		
	# emit signal, play death anim
	died.emit(self)
	queue_free.call_deferred()
