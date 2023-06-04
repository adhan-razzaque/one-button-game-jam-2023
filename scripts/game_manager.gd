extends Node


@export var scenes_list: Array[Resource] = []
@export var background_music: AudioStream

var current_scene: Node = null
var current_scene_index := 0
var current_tile_map: TileMap


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	# for scene in scenes_list:
	# 	if scene and get_node(scene.resource_path) is Node:
	# 		continue

	# 	push_error("Scenes list must only contain scenes")
	
	call_deferred("_play_background_music_deferred")


func _play_background_music_deferred() -> void:
	SoundManager.set_sound_volume(0.6)
	SoundManager.play_music_at_volume(background_music, -8)


func restart_scenes() -> void:
	current_scene_index = -1
	goto_next_scene()


func reload_current_scene_index() -> void:
	goto_scene(scenes_list[current_scene_index].resource_path)


func goto_next_scene() -> void:
	if current_scene_index + 1 == scenes_list.size() or current_scene_index < -1:
		return

	current_scene_index += 1

	goto_scene(scenes_list[current_scene_index].resource_path)


func goto_scene(path) -> void:
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path) -> void:
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
