class_name Player
extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var pull_started := false
var pull_vector := Vector2()
var start_position := Vector2()

@onready var spawn_point := position

@export var _animator_path: NodePath = "AnimatedSprite2D"
@export var death_sound: AudioStream

@onready var animator: AnimatedSprite2D = get_node(_animator_path)


func respawn_player() -> void:
	if death_sound:
		SoundManager.play_sound(death_sound)
	position = spawn_point


func _on_state_machine_transitioned(_node_path: NodePath):
	# print("Transitioning to node at " + _node_path.get_concatenated_names())
	pass
