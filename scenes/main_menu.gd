extends Control

#@onready var save_manager: SaveManager = $SaveManager
@onready var total_shards_label: Label = $CanvasLayer/CenterContainer/VBoxContainer/TotalShardsLabel
@onready var play_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/PlayButton
@onready var upgrades_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/UpgradesButton
@onready var sandbox_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/SandboxButton


func _ready() -> void:
	total_shards_label.text = "Shards: %d" % Save.total_shards
	play_button.pressed.connect(_on_play)
	play_button.button_up.connect(_on_play_up)
	sandbox_button.pressed.connect(_on_sandbox)
	sandbox_button.button_up.connect(_on_sandbox_up)
	upgrades_button.pressed.connect(_on_upgrades)
	upgrades_button.button_up.connect(_on_upgrades_up)

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

func _on_upgrades() -> void:
	print("upgrades")
	get_tree().change_scene_to_file("res://scenes/meta_upgrades/meta_upgrade_screen.tscn")
	
func _on_upgrades_up() -> void:
	print("upgrades up")
	get_tree().change_scene_to_file("res://scenes/meta_upgrades/meta_upgrade_screen.tscn")
