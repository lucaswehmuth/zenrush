extends Node2D

@onready var player: Player = $Player
@onready var spawn_manager: SpawnManager = $SpawnManager
#@onready var save_manager: SaveManager = $SaveManager
@onready var touch_controls: CanvasLayer = $Control/TouchControls
@onready var quit_button: Button = $CanvasLayer/MarginContainer/QuitButton
@onready var upgrade_manager: UpgradeManager = $UpgradeManager
@onready var upgrade_screen: Control = $CanvasLayer/UpgradeScreen
@onready var meta_progression_manager: MetaProgressionManager = $MetaProgressionManager
@onready var end_screen: Control = $CanvasLayer/EndScreen


func _ready() -> void:
	player.died.connect(_on_player_died)
	quit_button.pressed.connect(_on_quit)
	spawn_manager.upgrade_available.connect(_on_upgrade_available)
	spawn_manager.run_completed.connect(_on_run_completed)
	upgrade_screen.upgrade_chosen.connect(_on_upgrade_chosen)
	player.apply_meta_stats(meta_progression_manager.get_meta_stats())

func _on_run_completed() -> void:
	var shards_earned = int(player.shards * player.completion_bonus_multiplier)
	Save.add_shards(shards_earned)
	spawn_manager.stop_run()
	touch_controls.hide()
	player.set_physics_process(false)
	player.hide()
	player.hurtbox.hurt.disconnect(player._on_hurt)
	_freeze_enemies()
	quit_button.hide()
	end_screen.show_end(spawn_manager.elapsed_time, spawn_manager.enemies_killed, shards_earned, Save.total_shards, true, player.completion_bonus_multiplier)
	
func _freeze_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_process(false)
		enemy.set_physics_process(false)
		
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
	Save.add_shards(player.shards)
	spawn_manager.stop_run()
	touch_controls.hide()
	end_screen.show_end(spawn_manager.elapsed_time, spawn_manager.enemies_killed, player.shards, Save.total_shards, false)

func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
