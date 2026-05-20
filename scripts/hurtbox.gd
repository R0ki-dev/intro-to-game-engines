extends Area2D

@onready var breakable_block: Node2D = $"."

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hitbox"):
		breakable_block.visible = false
