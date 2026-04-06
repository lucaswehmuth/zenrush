extends Node2D

@onready var player: Player = $Player
@onready var spawn_manager: SpawnManager = $SpawnManager
@onready var save_manager: SaveManager = $SaveManager
@onready var touch_controls: CanvasLayer = $Control/TouchControls
@onready var quit_button: Button = $CanvasLayer/MarginContainer/QuitButton
@onready var upgrade_manager: UpgradeManager = $UpgradeManager
@onready var upgrade_screen: Control = $CanvasLayer/UpgradeScreen
@onready var end_screen: Control = $CanvasLayer/EndScreen


func _ready() -> void:
	player.died.connect(_on_player_died)
	quit_button.pressed.connect(_on_quit)
	spawn_manager.upgrade_available.connect(_on_upgrade_available)
	spawn_manager.run_completed.connect(_on_run_completed)
	upgrade_screen.upgrade_chosen.connect(_on_upgrade_chosen)

func _on_run_completed() -> void:
	var shards_earned = int(player.shards * player.completion_bonus_multiplier)
	save_manager.add_shards(shards_earned)
	spawn_manager.stop_run()
	touch_controls.hide()
	player.set_physics_process(false)
	player.hide()
	quit_button.hide()
	end_screen.show_end(spawn_manager.elapsed_time, spawn_manager.enemies_killed, shards_earned, save_manager.total_shards, true, player.completion_bonus_multiplier)
	
func _on_upgrade_available() -> void:
	var offers = upgrade_manager.get_upgrade_offers()
	if offers.is_empty():
		return
	get_tree().paused = true
	upgrade_screen.show_upgrades(offers)

func _on_upgrade_chosen(upgrade: BaseUpgrade) -> void:
	upgrade_manager.remove_upgrade(upgrade)
	if upgrade is BasePlayerUpgrade:
		upgrade.apply(player)
	elif upgrade is BaseProjectileUpgrade:
		player.projectile_upgrades.append(upgrade)
	get_tree().paused = false

func _on_player_died() -> void:
	save_manager.add_shards(player.shards)
	spawn_manager.stop_run()
	touch_controls.hide()
	end_screen.show_end(spawn_manager.elapsed_time, spawn_manager.enemies_killed, player.shards, save_manager.total_shards, false)

func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
