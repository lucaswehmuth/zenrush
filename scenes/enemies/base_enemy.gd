class_name BaseEnemy
extends CharacterBody2D

signal died(enemy: BaseEnemy)

@onready var hurtbox: Hurtbox = $Hurtbox

@export var max_health: float = 100.0
@export var move_speed: float = 80.0
@export var damage: float = 10.0
@export var shard_value: int = 1

var current_health: float
var player: Node2D

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("player")
	hurtbox.hurt.connect(_on_hurt)

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
	if attacker is BaseProjectile:
		take_damage(attacker.damage)
		attacker.queue_free()

func take_damage(amount: float) -> void:
	current_health -= amount
	print(self, "Took damage - health:", current_health)
	if current_health <= 0.0:
		die()

func die() -> void:
	# emit signal, drop shards, play death anim
	died.emit(self)
	queue_free()
