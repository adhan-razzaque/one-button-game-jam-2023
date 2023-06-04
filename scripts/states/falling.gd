class_name Falling
extends PlayerState


@export var mass: float = 1.0
@export var fall_animation_name: StringName
@export var teleport_sound: AudioStream
@export_flags_2d_physics var collision_layer: int = 1
@export_flags_2d_physics var collision_mask: int = 1

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

	for i in player.get_slide_collision_count():
		var collision: KinematicCollision2D = player.get_slide_collision(i)
		
		var tilemap: TileMap = collision.get_collider() as TileMap
		if tilemap:
			print("I collided with ", collision.get_collider().name)
			_handle_teleport_collision(collision, tilemap)


func enter(_msg := {}) -> void:
	_play_fall_animation()
	player.collision_layer = collision_layer
	player.collision_mask = collision_mask


func _play_fall_animation() -> void:
	if fall_animation_name.is_empty():
		return
	
	player.animator.play(fall_animation_name)

func _handle_teleport_collision(collision: KinematicCollision2D, tilemap: TileMap) -> void:
	var coords: Vector2i = tilemap.get_coords_for_body_rid(collision.get_collider_rid())
	var data: TileData = tilemap.get_cell_tile_data(1, coords)

	if not data:
		return

	var is_teleport: bool = data.get_custom_data("is_teleport") as bool

	if not is_teleport:
		return
	
	if teleport_sound:
		SoundManager.play_sound(teleport_sound)
	GameManager.goto_next_scene()
