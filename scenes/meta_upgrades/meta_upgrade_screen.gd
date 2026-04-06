extends Control

@onready var upgrade_list = $RootVBox/UpgradeList
@onready var meta_progression_manager: MetaProgressionManager = $MetaProgressionManager

const UPGRADE_ITEM_SCENE = preload("res://scenes/meta_upgrades/meta_upgrade_item.tscn")
const UPGRADES = [
	preload("res://scenes/meta_upgrades/damage_meta_upgrade.tres")
]

func _ready() -> void:
	populate()

func populate() -> void:
	for child in upgrade_list.get_children():
		child.queue_free()

	for upgrade in UPGRADES:
		var item = UPGRADE_ITEM_SCENE.instantiate()
		upgrade_list.add_child(item)

		var _id: String = upgrade.id
		var _name: String = upgrade.name

		var _level: int = meta_progression_manager.get_level(_id)
		var _cost: int = meta_progression_manager.get_cost(_id)
		var shards: int = Save.total_shards

		var can_afford: bool = shards >= _cost

		item.setup(_id, _name, _level, _cost, can_afford)
		item.buy_pressed.connect(_on_item_buy_pressed)

func _on_item_buy_pressed(id: String) -> void:
	var success := meta_progression_manager.purchase(id)

	if success:
		populate()
