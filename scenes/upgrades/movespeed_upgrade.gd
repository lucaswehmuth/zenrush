class_name MoveSpeedUpgrade
extends BasePlayerUpgrade

@export var speed_bonus: float = 30.0

func _init() -> void:
	upgrade_name = "Move Speed Up"
	description = "Increases movement speed"

func apply(player: Player) -> void:
	player.move_speed += speed_bonus
