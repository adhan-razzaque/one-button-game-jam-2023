class_name Player
extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var pull_started := false
var pull_vector := Vector2()
var start_position := Vector2()

@export var animator_path: NodePath = "AnimatedSprite2D"

@onready var animated_sprite: AnimatedSprite2D = get_node(animator_path)


func _on_state_machine_transitioned(_node_path: NodePath):
	# print("Transitioning to node at " + _node_path.get_concatenated_names())
	pass
