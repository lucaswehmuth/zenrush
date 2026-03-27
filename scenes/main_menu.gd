extends Control

@onready var save_manager: SaveManager = $SaveManager
@onready var total_shards_label: Label = $CanvasLayer/CenterContainer/VBoxContainer/TotalShardsLabel
@onready var play_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/PlayButton
@onready var sandbox_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/SandboxButton

func _ready() -> void:
	total_shards_label.text = "Shards: %d" % save_manager.total_shards
	play_button.pressed.connect(_on_play)
	sandbox_button.pressed.connect(_on_sandbox)

func _on_play() -> void:
	print("play")
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_sandbox() -> void:
	print("sandbox")
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")

func _input(event):
	if event is InputEventScreenTouch:
		print("TOUCH DETECTED:", event.position)
