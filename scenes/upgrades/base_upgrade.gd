class_name BaseUpgrade
extends Resource

enum Category { HP, ATTACK, SPECIAL }

@export var upgrade_name: String = ""
@export var description: String = ""
@export var icon: Texture2D
var category: Category
