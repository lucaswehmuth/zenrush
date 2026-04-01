class_name ShardMagnetUpgrade
extends BasePlayerUpgrade

func _init() -> void:
	upgrade_name = "Shard Magnet"
	description = "Shards automatically move toward you"

func apply(player: Player) -> void:
	player.shard_magnet = true
