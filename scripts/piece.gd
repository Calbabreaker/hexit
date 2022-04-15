extends Sprite
class_name Piece

# Radius of the hexagon in pixel coordinates
const SIZE := 30
const SIZE_VECTOR := Vector2(SIZE, SIZE)

func _enter_tree() -> void:
	fit_to_size()

# Scales the node to the piece size constant based on texture size
func fit_to_size():
	var size = texture.get_size()
	scale = SIZE_VECTOR * 2 / size
	
# Rounds the hex coordinates to the nearest integer
static func axial_round(hex: Vector2) -> Vector2:
	var grid = hex.round()
	hex -= grid
	if pow(hex.x, 2) >= pow(hex.y, 2):
		grid.x += round(hex.x + hex.y / 2)
	if pow(hex.x, 2) < pow(hex.y, 2):
		grid.y += round(hex.y + hex.x / 2)
	return grid

# Converts pixel coordinates to hexagon grid coordinates
static func pixel_to_hex(pixel: Vector2) -> Vector2:
	var x = (2.0/3 * pixel.x) / SIZE
	var y = (-1.0/3 * pixel.x + sqrt(3.0)/3 * pixel.y) / SIZE
	return axial_round(Vector2(x, y))

# Converts hexagon grid coordinates to pixel coordinates
static func hex_to_pixel(hex: Vector2) -> Vector2:
	var x = SIZE * (3.0/2 * hex.x)
	var y = SIZE * (sqrt(3.0)/2 * hex.x + sqrt(3) * hex.y)
	return Vector2(x, y)
