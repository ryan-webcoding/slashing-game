extends Camera2D

@export var target: Node2D
@export var smoothing_speed: float = 20.0

func _process(delta):
	if target:
		global_position = global_position.lerp(target.global_position, delta * smoothing_speed)
