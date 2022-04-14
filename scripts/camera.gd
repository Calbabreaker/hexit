extends Camera2D

export var speed: float
export var zoom_speed: float
export var min_zoom: float
export var max_zoom: float

var zoom_scale := 1.0
var real_zoom := zoom_scale

func _process(delta: float) -> void:
	# Figure out direcion vector from movement keys (WASD, arrow keys)
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized() # Prevents diagonal movement from being faster
	
	# Calculates velocity and adds it onto the position to move the camera
	position += direction * speed * delta * real_zoom 
	
	# Interpolate zoom for smoothness
	real_zoom = lerp(real_zoom, zoom_scale, 0.2)
	zoom = Vector2.ONE * pow(real_zoom, 2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_scroll_up"):
		zoom_scale -= zoom_speed
		update_zoom()
	if event.is_action_pressed("ui_scroll_down"):
		zoom_scale += zoom_speed
		update_zoom()
	
func update_zoom():
	zoom_scale = clamp(zoom_scale, min_zoom, max_zoom)

