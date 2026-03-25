class_name Shard
extends Area2D

var value: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.shards += value
		print("Shards: ", body.shards)
		queue_free()
