extends Control


@export var frequency: float = 1.0
@export var amplitude: float = 1.0
@export var hover_range: int = 10

@onready var _start_position := position
var _time_elapsed: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_elapsed += delta
	var shift: float = float(hover_range) * sin(_time_elapsed * frequency) * amplitude
	var shift_floor: int = floori(shift)

	position.y = _start_position.y + shift_floor

