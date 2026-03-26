class_name BurstUpgrade
extends BasePlayerUpgrade

func apply(player: Player) -> void:
	player.burst_count += 1
