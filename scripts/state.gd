class_name State
extends Node


var state_machine: StateMachine = null

## Handle input events from `_unhandled_input()`
func handle_input(_event: InputEvent) -> void:
	pass


## Handle updates for `_process()`
func update(_delta: float) -> void:
	pass


## Handle updates foor `_physics_process()`
func physics_update(_delta: float) -> void:
	pass


## Called upon state becoming active. `msg` is a dictionary to store arbitrary
## data for use with initialization
func enter(_msg := {}) -> void:
	pass


## Called when state is becoming inactive.
func exit() -> void:
	pass
