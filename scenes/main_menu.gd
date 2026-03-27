extends Control

@onready var save_manager: SaveManager = $SaveManager
@onready var total_shards_label: Label = $CanvasLayer/CenterContainer/VBoxContainer/TotalShardsLabel
@onready var play_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/PlayButton
@onready var sandbox_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/SandboxButton
@onready var test_button: Button = $TestButton

func _ready() -> void:
	total_shards_label.text = "Shards: %d" % save_manager.total_shards
	play_button.pressed.connect(_on_play)
	play_button.button_up.connect(_on_play_up)
	sandbox_button.pressed.connect(_on_sandbox)
	sandbox_button.button_up.connect(_on_sandbox_up)
	test_button.pressed.connect(_on_test_pressed)
	test_button.button_up.connect(_on_test_up)

func _on_play() -> void:
	print("play")
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _on_play_up() -> void:
	print("play up")
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_sandbox() -> void:
	print("sandbox")
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")
	
func _on_sandbox_up() -> void:
	print("sandbox up")
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")

func _on_test_pressed() -> void:
	print("test")
	
func _on_test_up() -> void:
	print("test up")
	
func _input(event):
	if event is InputEventScreenTouch:
		print("TOUCH DETECTED:", event.position)
