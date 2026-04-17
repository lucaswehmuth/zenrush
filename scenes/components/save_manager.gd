class_name SaveManager
extends Node

const SAVE_PATH = "user://savegame.cfg"

var total_shards: int = 0
var meta_levels: Dictionary = {}   # id -> level

func _ready() -> void:
	load_game()
	if OS.is_debug_build():
		total_shards = 9999
		#meta_levels = {}

func add_shards(amount: int) -> void:
	total_shards += amount
	save_game()

func set_meta_levels(levels: Dictionary) -> void:
	meta_levels = levels.duplicate()
	save_game()

func get_meta_levels() -> Dictionary:
	return meta_levels.duplicate()

func save_game() -> void:
	var config = ConfigFile.new()

	# player
	config.set_value("player", "total_shards", total_shards)

	# meta progression
	for id in meta_levels.keys():
		config.set_value("meta", id, meta_levels[id])

	config.save(SAVE_PATH)

func load_game() -> void:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return

	# player
	total_shards = config.get_value("player", "total_shards", 0)

	# meta progression
	meta_levels.clear()

	var keys = config.get_section_keys("meta")
	if keys != null:
		for id in keys:
			meta_levels[id] = int(config.get_value("meta", id, 0))
