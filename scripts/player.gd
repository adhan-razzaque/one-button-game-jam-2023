class_name Player
extends CharacterBody2D


@export var speed := 10.0
@export var throw_modifier := 1.2
@export var max_throw_length := 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var pull_started := false
var pull_vector := Vector2()
var start_position := Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			pull_started = true
			start_position = event.position
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			print("Left button was released at ", event.position)
			pull_vector = event.position - start_position
			var max_throw = Vector2(max_throw_length, max_throw_length)
			pull_vector = pull_vector.clamp(-max_throw, max_throw)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement
	if not pull_vector.is_zero_approx():
		velocity = pull_vector * throw_modifier
		pull_vector = Vector2()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
