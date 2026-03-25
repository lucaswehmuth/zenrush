class_name SaveManager
extends Node

const SAVE_PATH = "user://savegame.cfg"

var total_shards: int = 0

func _ready() -> void:
	load_game()

func add_shards(amount: int) -> void:
	total_shards += amount
	save_game()

func save_game() -> void:
	var config = ConfigFile.new()
	config.set_value("player", "total_shards", total_shards)
	config.save(SAVE_PATH)

func load_game() -> void:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	total_shards = config.get_value("player", "total_shards", 0)
