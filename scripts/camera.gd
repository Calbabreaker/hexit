extends Camera2D

export var speed: float
export var max_speed: float

var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	velocity + clamp(velocity + direction * speed, -max_speed, max_speed)
	position += velocity * delta
