class_name UIAudioPlayer
extends Node

@export var button_press_sound: AudioStream
@export var button_hover_sound: AudioStream



func _on_button_pressed() -> void:
	if not button_press_sound:
		return
	
	SoundManager.play_sound(button_press_sound)

func _on_button_entered() -> void:
	if not button_hover_sound:
		return

	SoundManager.play_sound(button_hover_sound)
