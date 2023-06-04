class_name MainMenu
extends Control


@export_file var start_scene_path: String
@export_file var controls_scene_path: String


func _on_start_button_pressed() -> void:
	if start_scene_path.is_empty():
		return

	# Hacked in a delay to allow button click to play
	await get_tree().create_timer(0.1).timeout

	GameManager.goto_next_scene()


func _on_controls_button_pressed() -> void:
	if controls_scene_path.is_empty():
		return

	var controls_scene: Node = load(controls_scene_path).instance()
	get_tree().current_scene.add_child(controls_scene)
