class_name Grounded
extends PlayerState

@export var horizontal_damping := 10.0
@export var throw_modifier := 1.2
@export var max_throw_length := 500.0
@export var min_throw_length := 1.0

var pull_started := false
var pull_vector := Vector2()
var start_position := Vector2()


# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# We must declare all the properties we access through `player` in the `Player.gd` script.
	player.velocity = Vector2.ZERO


## Handle input events from `_unhandled_input()`
func handle_input(_event: InputEvent) -> void:
	var mouseEvent := _event as InputEventMouseButton
	if mouseEvent:
		handle_mouse_input(mouseEvent)


func handle_mouse_input(_event: InputEventMouseButton) -> void:
	if _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed:
		print("Left button was clicked at ", _event.position)
		pull_started = true
		start_position = _event.position
	if _event.button_index == MOUSE_BUTTON_LEFT and not _event.pressed:
		print("Left button was released at ", _event.position)
		calculate_pull(start_position, _event.position)


func calculate_pull(start: Vector2, end: Vector2) -> void:
	
	var dist: Vector2 = start - end
	
	if dist.length() > max_throw_length:
		dist = dist.normalized() * max_throw_length
		
	if dist.length() < min_throw_length:
		pull_vector = Vector2.ZERO
		state_transition("Grounded", true)
		return
	
	# Remap to cubic ease out curve
	var dist_sign: Vector2 = dist.sign()
	dist = dist.abs()
	dist /= max_throw_length
	dist.x = Easing.Cubic.EaseOut(dist.x, 0, 1, 1)
	dist.y = Easing.Cubic.EaseOut(dist.y, 0, 1, 1)
	dist *= max_throw_length
	dist *= dist_sign

	pull_vector = dist


func physics_update(_delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if not player.is_on_floor():
		state_transition("Falling")
		return

	# Movement
	if not pull_vector.is_zero_approx():
		player.velocity = pull_vector * throw_modifier
		pull_vector = Vector2.ZERO
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, horizontal_damping)

	player.move_and_slide()
