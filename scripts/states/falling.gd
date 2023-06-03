class_name Falling
extends PlayerState


@export var mass: float = 1.0
@export var fall_animation_name: StringName

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

## Handle input events from `_unhandled_input()`
func handle_input(_event: InputEvent) -> void:
	var mouseEvent := _event as InputEventMouseButton
	if mouseEvent:
		handle_mouse_input(mouseEvent)


func handle_mouse_input(_event: InputEventMouseButton) -> void:
	if _event.button_index == MOUSE_BUTTON_LEFT and not _event.pressed:
		state_transition("Falling", true)


func physics_update(delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if player.is_on_floor():
		state_transition("Grounded")
		return

	# Add the gravity.
	player.velocity.y += gravity * mass * delta

	player.move_and_slide()


func enter(_msg := {}) -> void:
	_play_fall_animation()


func _play_fall_animation() -> void:
	if fall_animation_name.is_empty():
		return
	
	player.animator.play(fall_animation_name)
