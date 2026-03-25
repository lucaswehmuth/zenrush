extends Node2D

@onready var player: Player = $Player
@onready var spawn_manager: SpawnManager = $SpawnManager
@onready var save_manager: SaveManager = $SaveManager
@onready var touch_controls: CanvasLayer = $Control/TouchControls

func _ready() -> void:
	get_tree().get_root().print_tree_pretty()
	player.died.connect(_on_player_died)

func _on_player_died() -> void:
	save_manager.add_shards(player.shards)
	spawn_manager.stop_run()
	touch_controls.hide()
	$CanvasLayer/DeathScreen.show_death(spawn_manager.elapsed_time, spawn_manager.enemies_killed, player.shards, save_manager.total_shards)
