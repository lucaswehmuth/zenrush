extends Control

@onready var stats_label: Label = $StatsLabel
@onready var restart_button: Button = $RestartButton


func _ready() -> void:
	hide()
	print(restart_button)
	restart_button.pressed.connect(_on_restart)

func show_death(elapsed: float, enemies_killed: int) -> void:
	var minutes = int(elapsed / 60.0)
	var seconds = int(fmod(elapsed, 60.0))
	stats_label.text = "Time survived: %02d:%02d\nEnemies killed: %d" % [minutes, seconds, enemies_killed]
	show()

func _on_restart() -> void:
	print("restarting")
	get_tree().reload_current_scene()
