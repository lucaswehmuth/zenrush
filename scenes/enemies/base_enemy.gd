class_name BaseEnemy
extends CharacterBody2D

signal died(enemy: BaseEnemy)

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_bar: HealthBar = $HealthBar

@export var max_health: float = 100.0
@export var move_speed: float = 80.0
@export var damage: float = 10.0
@export var shard_value: int = 1
@export var shard_scene: PackedScene

var current_health: float
var player: Node2D

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("player")
	hurtbox.hurt.connect(_on_hurt)
	health_bar.init(max_health)

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
		take_damage(attacker.damage)
		if attacker.explodes:
			attacker._explode()
		if attacker.pierce_count <= 0:
			attacker.queue_free()
		else:
			attacker.pierce_count -= 1

func take_damage(amount: float) -> void:
	current_health -= amount
	health_bar.health = current_health
	if current_health <= 0.0:
		die()

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
