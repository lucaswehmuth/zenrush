extends Control

@onready var title_label: Label = $TitleLabel
@onready var stats_label: Label = $StatsLabel
@onready var restart_button: Button = $RestartButton
@onready var menu_button: Button = $MenuButton


func _ready() -> void:
	hide()
	restart_button.pressed.connect(_on_restart)
	menu_button.pressed.connect(_on_menu)

func show_end(elapsed: float, enemies_killed: int, shards_earned: int, total_shards: int, completed: bool, 
bonus_multiplier: float = 1.0) -> void:
	var minutes = int(elapsed / 60.0)
	var seconds = int(fmod(elapsed, 60.0))
	if completed:
		title_label.text = "Run Complete!"
		stats_label.text = "Time survived: %02d:%02d\nEnemies killed: %d\nShards earned: %d (x%.1f bonus!)\nTotal shards: %d" % [minutes, seconds, enemies_killed, shards_earned, bonus_multiplier, total_shards]
	else:
		title_label.text = "You Died."
		stats_label.text = "Time survived: %02d:%02d\nEnemies killed: %d\nShards earned: %d\nTotal shards: %d" % [minutes, seconds, enemies_killed, shards_earned, total_shards]
	
	show()

func _on_restart() -> void:
	get_tree().reload_current_scene()

func _on_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
