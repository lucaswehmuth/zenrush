extends CharacterBody2D

const SPEED = 300.0
var input_vector = Vector2.ZERO

@export var projectile_scene: PackedScene
@export var attack_range: float = 300.0
@export var attack_cooldown: float = 0.8
var attack_timer: float = 0.0

func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * SPEED
	
	attack_timer -= delta
	if attack_timer <= 0.0:
		var target = _get_nearest_enemy()
		if target:
			print(target)
			_shoot(target)
			attack_timer = attack_cooldown
			
	move_and_slide()

func _shoot(target: BaseEnemy) -> void:
	if not projectile_scene:
		return
	var projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	var direction = (target.global_position - global_position).normalized()
	projectile.init(global_position, direction)
	
func _get_nearest_enemy() -> BaseEnemy:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest: BaseEnemy = null
	var nearest_dist = attack_range

	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
				
	return nearest
