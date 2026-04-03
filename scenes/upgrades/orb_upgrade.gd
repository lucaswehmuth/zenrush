class_name OrbUpgrade
extends BasePlayerUpgrade

@export var orb_scene: PackedScene
@export var orb_count: int = 3

func _init() -> void:
	upgrade_name = "Orbiting orb"
	description = "Orbs that inflict damage"
	category = BaseUpgrade.Category.SPECIAL
	
func apply(player: Player) -> void:
	for i in orb_count:
		var orb = orb_scene.instantiate()
		player.get_parent().add_child(orb)
		var starting_angle = (TAU / orb_count) * i
		orb.setup(player, starting_angle)
