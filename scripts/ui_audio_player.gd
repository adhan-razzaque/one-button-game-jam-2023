class_name UIAudioPlayer
extends Node


@export var button_press_stream_path: NodePath
@export var button_hover_stream_path: NodePath

var _button_press_stream: AudioStreamPlayer
var _button_hover_stream: AudioStreamPlayer


func _ready() -> void:
    if not button_press_stream_path.is_empty():
        _button_press_stream = get_node(button_press_stream_path)
    
    if not button_hover_stream_path.is_empty():
        _button_hover_stream = get_node(button_hover_stream_path)


func _on_button_pressed() -> void:
    if not _button_press_stream:
        return
    
    _button_press_stream.play()

func _on_button_entered() -> void:
    if not _button_hover_stream:
        return

    _button_hover_stream.play()
