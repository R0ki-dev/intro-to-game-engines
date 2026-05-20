extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true
func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false

# Needs to unpause before loading scene, otherwise gets softlocked
func _on_button_2_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
