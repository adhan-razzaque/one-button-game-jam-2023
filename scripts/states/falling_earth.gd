class_name FallingEarth
extends Falling


@export var break_sound: AudioStream


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
			var is_teleport = _handle_teleport_collision(collision, tilemap)
			if is_teleport:
				break
			_handle_tilemap_collision(collision, tilemap)


func _handle_tilemap_collision(collision: KinematicCollision2D, tilemap: TileMap) -> void:
	var coords: Vector2i = tilemap.get_coords_for_body_rid(collision.get_collider_rid())
	var data: TileData = tilemap.get_cell_tile_data(1, coords)

	if not data:
		return

	var is_breakable: bool = data.get_custom_data("breakable") as bool

	if not is_breakable:
		return
	
	tilemap.erase_cell(1, coords)
	if break_sound:
		SoundManager.play_sound(break_sound)
