class_name AttackRangeUpgrade
extends BasePlayerUpgrade

@export var range_percent_bonus: float = 0.3

func _init() -> void:
	upgrade_name = "Attack Range"
	description = "Increases auto-attack range"
	category = BaseUpgrade.Category.ATTACK

func apply(player: Player) -> void:
	player.attack_range_percent += range_percent_bonus
	player.queue_redraw()
