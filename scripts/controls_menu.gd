class_name ControlsMenu
extends Control


func _on_back_button_pressed() -> void:
	call_deferred("_on_back_button_pressed_deferred")

func _on_back_button_pressed_deferred() -> void:
	self.queue_free()
