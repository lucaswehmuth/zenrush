extends Control

@onready var save_manager: SaveManager = $SaveManager
@onready var total_shards_label: Label = $CanvasLayer/CenterContainer/VBoxContainer/TotalShardsLabel
@onready var play_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/PlayButton


func _ready() -> void:
	total_shards_label.text = "Shards: %d" % save_manager.total_shards
	play_button.pressed.connect(_on_play)

func _on_play() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
