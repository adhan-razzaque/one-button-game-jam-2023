class_name Grounded
extends PlayerState

@export var horizontal_damping := 10.0
@export var vertical_modifier := 1.0
@export var horizontal_modifier := 1.0
@export var max_throw_length := 500.0
@export var min_throw_length := 1.0
@export var idle_animation_name: StringName
@export var run_animation_name: StringName
@export var line2D_path: NodePath

@onready var _line2D := get_node(line2D_path) as Line2D

var pull_started := false
var pull_vector := Vector2()
var start_position := Vector2()
var _is_sliding := false


func _ready() -> void:
	super._ready()
	_line2D.visible = false
	assert(_line2D.points.size() == 2)


# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# We must declare all the properties we access through `player` in the `Player.gd` script.
	player.velocity = Vector2.ZERO

	_play_idle_animation()


## Handle input events from `_unhandled_input()`
func handle_input(_event: InputEvent) -> void:
	var mouseButtonEvent := _event as InputEventMouseButton
	if mouseButtonEvent:
		handle_mouse_button_input(mouseButtonEvent)
		return

	var mouseEvent := _event as InputEventMouse
	if mouseEvent:
		handle_mouse_input(mouseEvent)
		return


func handle_mouse_input(_event: InputEventMouse) -> void:
	if not pull_started:
		return
	
	var cursor_pos: Vector2 = _event.position
	var line_vector: Vector2 = cursor_pos - start_position

	if line_vector.length() > max_throw_length:
		cursor_pos = start_position + (line_vector.normalized() * max_throw_length)

	_line2D.set_point_position(1, cursor_pos)


func handle_mouse_button_input(_event: InputEventMouseButton) -> void:
	if _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed:
		print("Left button was clicked at ", _event.position)
		pull_started = true
		start_position = _event.position
		_line2D.visible = true
		_line2D.set_point_position(0, start_position)
		_line2D.set_point_position(1, start_position)
	if _event.button_index == MOUSE_BUTTON_LEFT and not _event.pressed:
		print("Left button was released at ", _event.position)
		calculate_pull(start_position, _event.position)
		_line2D.visible = false


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

	dist.x *= horizontal_modifier
	dist.y *= vertical_modifier

	pull_vector = dist


func physics_update(_delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if not player.is_on_floor():
		state_transition("Falling")
		return

	# Animation Selection
	if abs(player.velocity.x) > 0:
		if not _is_sliding:
			_play_run_animation()
			_is_sliding = true
	else:
		if _is_sliding:
			_play_idle_animation()
			_is_sliding = false

	# Movement
	if not pull_vector.is_zero_approx():
		player.velocity = pull_vector
		pull_vector = Vector2.ZERO
		_play_run_animation()
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, horizontal_damping)
		if player.velocity.x == 0:
			_play_idle_animation()

	player.move_and_slide()


func _play_idle_animation() -> void:
	if idle_animation_name.is_empty():
		return
	
	player.animator.play(idle_animation_name)


func _play_run_animation() -> void:
	if run_animation_name.is_empty():
		return

	player.animator.play(run_animation_name)
