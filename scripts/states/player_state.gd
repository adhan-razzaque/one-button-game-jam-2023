## Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
## Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name PlayerState
extends State

enum ElementType {EARTH, AIR, WATER, FIRE}

@export var element: ElementType = ElementType.EARTH

## Typed reference to the player node.
var player: Player


func _ready() -> void:
	player = owner as Player
	assert(player != null)


func next_element() -> ElementType:
	if element == ElementType.EARTH:
		return ElementType.AIR
	elif element == ElementType.AIR:
		return ElementType.WATER
	elif element == ElementType.WATER:
		return ElementType.FIRE
	elif element == ElementType.FIRE:
		return ElementType.EARTH
	else:
		push_error("Invalid Element state")
		return ElementType.AIR


func state_transition(state: String, to_next: bool = false) -> void:
	var element_name: ElementType = next_element() if to_next else element
	state_machine.transition_to(state + PlayerState.element_string(element_name))


static func element_string(element_type: ElementType) -> String:
	if element_type == ElementType.EARTH:
		return "Earth"
	elif element_type == ElementType.AIR:
		return "Air"
	elif element_type == ElementType.WATER:
		return "Water"
	elif element_type == ElementType.FIRE:
		return "Fire"
	else:
		push_error("Invalid Element state")
		return ""
