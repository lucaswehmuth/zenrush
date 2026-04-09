extends Node2D
class_name MetaProgressionManager

# player_stat_key maps to Player property names (e.g. "base_damage", "move_speed").
# Applied at run start via get_meta_stats() → Player.apply_meta_stats().
@export var upgrades_path: String = "res://scenes/meta_upgrades/resources/"

# Cost curve: base_cost * growth^(level-1). At level 1: 10, level 2: 20, level 3: 40, etc.
const BASE_COST: int = 10
const COST_GROWTH: float = 2.0

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

func get_cost(id: String) -> int:
	var current_level: int = levels.get(id, 0)
	var next_level: int = current_level + 1
	return get_cost_for_level(next_level)

# The formula. Only called by get_cost.
func get_cost_for_level(level: int) -> int:
	return int(BASE_COST * pow(COST_GROWTH, level - 1))

func get_max_level(id: String) -> int:
	var upgrade: MetaUpgrade = upgrades[id]
	return upgrade.values_per_level.size()

func is_max_level(id: String) -> bool:
	return levels.get(id, 0) >= get_max_level(id)

func can_purchase(id: String, currency: int) -> bool:
	if is_max_level(id):
		return false
	if not meets_requirements(id):
		return false
	var cost = get_cost(id)
	return currency >= cost

func meets_requirements(id: String) -> bool:
	var upgrade: MetaUpgrade = upgrades[id]
	for req in upgrade.requirements:
		if levels.get(req.required_upgrade_id, 0) < req.required_level:
			return false
	return true

func purchase(id: String) -> bool:
	if not upgrades.has(id):
		push_error("Invalid upgrade id: " + id)
		return false

	if is_max_level(id):
		print("already maxed out")
		return false

	var cost = get_cost(id)

	if Save.total_shards < cost:
		print("not enough shards")
		return false

	Save.total_shards -= cost
	levels[id] += 1
	Save.set_meta_levels(levels)
	Save.save_game()

	return true

func get_level(id: String) -> int:
	return levels.get(id, 0)
	
func get_meta_stats() -> Dictionary:
	var stats: Dictionary = {}
	for id in upgrades.keys():
		var level: int = levels.get(id, 0)
		if level <= 0:
			continue
			
		var upgrade: MetaUpgrade = upgrades[id]
		if upgrade.player_stat_key == "" or upgrade.values_per_level.is_empty() or level > upgrade.values_per_level.size():
			push_error("MetaUpgrade misconfigured: " + upgrade.id)
			continue
			
		var key: String = upgrade.player_stat_key
		if not stats.has(key):
			stats[key] = 0.0
		stats[key] += upgrade.values_per_level[level - 1]
		
	return stats
