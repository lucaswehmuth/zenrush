class_name MultiShotUpgrade
extends BasePlayerUpgrade

@export var extra_shots_bonus: int = 1

func _init() -> void:
	upgrade_name = "Multi Shot"
	description = "Fires additional projectiles per shot"
	category = BaseUpgrade.Category.SPECIAL

func apply(player: Player) -> void:
	player.extra_shots += extra_shots_bonus
