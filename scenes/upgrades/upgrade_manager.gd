class_name UpgradeManager
extends Node2D

const OFFERS_COUNT: int = 2

var _all_upgrades: Array[BaseUpgrade] = [
	preload("res://scenes/upgrades/attackrange_upgrade.tres"),
	preload("res://scenes/upgrades/attackspeed_upgrade.tres"),
	preload("res://scenes/upgrades/burst_upgrade.tres"),
	preload("res://scenes/upgrades/damage_upgrade.tres"),
	preload("res://scenes/upgrades/explosive_upgrade.tres"),
	preload("res://scenes/upgrades/healthregen_upgrade.tres"),
	preload("res://scenes/upgrades/maxhealth_upgrade.tres"),
	preload("res://scenes/upgrades/movespeed_upgrade.tres"),
	preload("res://scenes/upgrades/multishot_upgrade.tres"),
	preload("res://scenes/upgrades/orb_upgrade.tres"),
	preload("res://scenes/upgrades/pierce_upgrade.tres"),
	preload("res://scenes/upgrades/shardmagnet_upgrade.tres"),
	preload("res://scenes/upgrades/vampirism_upgrade.tres"),
]

var _available_upgrades: Array[BaseUpgrade] = []

func _ready() -> void:
	_available_upgrades = _all_upgrades.duplicate()

func get_upgrade_offers() -> Array[BaseUpgrade]:
	var shuffled = _available_upgrades.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, OFFERS_COUNT)

func remove_upgrade(upgrade: BaseUpgrade) -> void:
	_available_upgrades.erase(upgrade)
