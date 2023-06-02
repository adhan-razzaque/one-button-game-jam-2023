class_name Player
extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var pull_started := false
var pull_vector := Vector2()
var start_position := Vector2()
