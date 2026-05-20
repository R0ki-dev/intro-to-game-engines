extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.add_dash()
	animation_player.play("pickup")
