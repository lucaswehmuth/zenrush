extends Control

@onready var upgrade_list: HFlowContainer = $RootVBox/ScrollContainer/UpgradeList
@onready var meta_progression_manager: MetaProgressionManager = $MetaProgressionManager
@onready var back_button: Button = $RootVBox/BackButton

const UPGRADE_ITEM_SCENE = preload("res://scenes/meta_upgrades/meta_upgrade_item.tscn")

func _ready() -> void:
	populate()
	back_button.pressed.connect(_on_back)

func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func populate() -> void:
	for child in upgrade_list.get_children():
		child.queue_free()
		
	for id in meta_progression_manager.upgrades.keys():
		var upgrade: MetaUpgrade = meta_progression_manager.upgrades[id]
		var item = UPGRADE_ITEM_SCENE.instantiate()
		upgrade_list.add_child(item)
		var _level: int = meta_progression_manager.get_level(id)
		var _cost: int = meta_progression_manager.get_cost(id)
		var is_maxed: bool = meta_progression_manager.is_max_level(id)
		var can_afford: bool = Save.total_shards >= _cost and not is_maxed
		var is_locked: bool = not meta_progression_manager.meets_requirements(id)
		item.setup(id, upgrade.name, _level, _cost, can_afford, is_maxed, is_locked)
		item.buy_pressed.connect(_on_item_buy_pressed)

func _on_item_buy_pressed(id: String) -> void:
	var success := meta_progression_manager.purchase(id)

	if success:
		populate()
