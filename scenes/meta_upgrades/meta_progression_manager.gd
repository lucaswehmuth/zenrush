extends Node2D
class_name MetaProgressionManager

@export var upgrades_path: String = "res://scenes/meta_upgrades/"

var base_cost: int = 10
var growth: float = 2.0
var upgrades: Dictionary = {}        # id -> MetaUpgrade
var levels: Dictionary = {}          # id -> current level

func _ready() -> void:
	load_all_upgrades()
	initialize_levels()
	# LOAD FROM SAVE
	var saved_levels = Save.get_meta_levels()

	for id in saved_levels.keys():
		if upgrades.has(id):
			levels[id] = saved_levels[id]

func load_all_upgrades() -> void:
	upgrades.clear()

	var dir := DirAccess.open(upgrades_path)
	if dir == null:
		push_error("Invalid upgrades path: " + upgrades_path)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var full_path = upgrades_path + file_name
			var res = load(full_path)

			if res is MetaUpgrade:
				var upgrade: MetaUpgrade = res

				if upgrade.id == "":
					push_error("MetaUpgrade missing id: " + full_path)
				else:
					upgrades[upgrade.id] = upgrade

		file_name = dir.get_next()

	dir.list_dir_end()

func initialize_levels() -> void:
	for id in upgrades.keys():
		if not levels.has(id):
			levels[id] = 0

func get_cost_for_level(level: int) -> int:
	return int(base_cost * pow(growth, level - 1))

func get_upgrade_cost(id: String) -> int:
	var current_level: int = levels.get(id, 0)
	var next_level: int = current_level + 1
	return get_cost_for_level(next_level)

func get_max_level(id: String) -> int:
	var upgrade: MetaUpgrade = upgrades[id]
	return upgrade.values_per_level.size()

func is_max_level(id: String) -> bool:
	return levels.get(id, 0) >= get_max_level(id)

func can_purchase(id: String, currency: int) -> bool:
	if is_max_level(id):
		return false

	var cost = get_upgrade_cost(id)
	return currency >= cost

func purchase(id: String) -> void:
	if not upgrades.has(id):
		push_error("Invalid upgrade id: " + id)
		return

	if is_max_level(id):
		return

	levels[id] += 1
	Save.set_meta_levels(levels)

func get_meta_stats() -> Dictionary:
	var stats: Dictionary = {}

	for id in upgrades.keys():
		var level: int = levels.get(id, 0)
		if level <= 0:
			continue

		var upgrade: MetaUpgrade = upgrades[id]

		# --- STRICT VALIDATION ---
		if upgrade.stat_key == "":
			push_error("MetaUpgrade missing stat_key: " + upgrade.id)
			continue

		if upgrade.values_per_level.is_empty():
			push_error("MetaUpgrade has no values_per_level: " + upgrade.id)
			continue

		if level > upgrade.values_per_level.size():
			push_error("Level exceeds values_per_level size for: " + upgrade.id)
			continue
		# ------------------------

		var value: float = upgrade.values_per_level[level - 1]
		var key: String = upgrade.stat_key

		if not stats.has(key):
			stats[key] = 0.0

		stats[key] += value

	return stats
