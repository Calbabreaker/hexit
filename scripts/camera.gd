extends Camera2D

export var speed: float
export var zoom_speed: float
export var min_zoom: float
export var max_zoom: float

var zoom_scale := 1.0
var real_zoom := zoom_scale

func _process(delta: float) -> void:
	# Figure out direcion vector from movement keys (WASD/arrow keys)
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized() # Prevents diagonal movement from being faster
	
	# Calculates velocity and adds it onto the position to move the camera
	position += direction * delta * speed * pow(real_zoom, 2)
	
	# Interpolate zoom for smoothness
	real_zoom = lerp(real_zoom, zoom_scale, 0.2)
	zoom = Vector2.ONE * pow(real_zoom, 2)

func _input(event: InputEvent) -> void:
	# Mouse scroll zoom functionality
	if event.is_action_pressed("ui_scroll_up"):
		zoom_camera(-zoom_speed, event.position)
	if event.is_action_pressed("ui_scroll_down"):
		zoom_camera(zoom_speed, event.position)
		
	# Mouse pan functionality
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_RIGHT) or Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			position -= event.relative * pow(real_zoom, 2)

func zoom_camera(zoom_factor: float, mouse_position: Vector2):
	# Constrain zoom amount
	zoom_scale = clamp(zoom_scale + zoom_factor, min_zoom, max_zoom)
	
	# Calculate where to move the camera so it will feel like we zoomed into that location
	var viewport_size = get_viewport().size
	var end_zoom = Vector2.ONE * pow(zoom_scale, 2)
	position += ((viewport_size * 0.5) - mouse_position) * (end_zoom-zoom)

# When button pressed reset camera zoom and position
func _on_Button_pressed() -> void:
	position = Vector2(0, 0)
	zoom_scale = 1
