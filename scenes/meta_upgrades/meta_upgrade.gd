extends Resource
class_name MetaUpgrade

enum Category { SURVIVAL, ATTACK, FORTUNE }

@export var id: String
@export var name: String
@export var description: String = ""
@export var icon: Texture2D

@export var category: Category

@export var values_per_level: Array[float] = []
@export var player_stat_key: String

@export var requirements: Array[MetaRequirement] = []
