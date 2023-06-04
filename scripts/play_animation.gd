extends AnimationPlayer


@export var animation_name: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(animation_name)