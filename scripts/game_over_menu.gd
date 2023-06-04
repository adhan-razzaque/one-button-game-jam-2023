class_name GameOverMenu
extends Control


func _on_restart_button_pressed() -> void:
	GameManager.restart_scenes()
