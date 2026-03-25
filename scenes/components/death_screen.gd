extends Control

@onready var stats_label: Label = $StatsLabel
@onready var restart_button: Button = $RestartButton
@onready var menu_button: Button = $MenuButton


func _ready() -> void:
	hide()
	print(restart_button)
	restart_button.pressed.connect(_on_restart)
	menu_button.pressed.connect(_on_menu)

func show_death(elapsed: float, enemies_killed: int, shards: int, total_shards: int) -> void:
	var minutes = int(elapsed / 60.0)
	var seconds = int(fmod(elapsed, 60.0))
	stats_label.text = "Time survived: %02d:%02d\nEnemies killed: %d\nShards collected: %d\nTotal shards: %d" % [minutes, seconds, enemies_killed, shards, total_shards]
	show()

func _on_restart() -> void:
	print("restarting")
	get_tree().reload_current_scene()

func _on_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
