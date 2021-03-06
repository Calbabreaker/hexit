extends Sprite
class_name Piece

# Radius of the hexagon in pixel coordinates
const SIZE := 30
const SIZE_VECTOR := Vector2(SIZE, SIZE)

# The offset index vector of each hexagonal side to go in that direction in a grid array starting at the bottom going clockwise
const SIDE_OFFSETS := [Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, -1), Vector2(1, 0)]

# Array of each the 6 sides containing the side type
var sides := []

func _ready() -> void:
	fit_to_size()
	set_sides()

# Scales the node to the piece size constant based on texture size
func fit_to_size():
	var size = texture.get_size()
	scale = SIZE_VECTOR * 2 / size

func set_sides():
	# Place random side types on each of the six sides
	for i in range(6):
		var side_type
		# 70% chance for the side type to be the same to have groups of side types
		if i != 0 and randf() < 0.70:
			side_type = sides[i - 1]
		else:
			# Else choose a random side type
			side_type = Global.PIECE_SIDES[randi() % len(Global.PIECE_SIDES)]
		sides.append(side_type)
		
		# Don't create the sprite if the texture doesn't exist
		if side_type.texture == null:
			continue
			
		# Create the sprite with some variance
		var side_sprite = Sprite.new()
		add_child(side_sprite)
		side_sprite.texture = side_type.texture
		side_sprite.rotation = randf() * TAU
		
		# Figure out position of the end of the side
		var side_angle = i / 6.0 * TAU + PI / 2 # The angle of the side of hexagonal in radians
		var side_position = Vector2(SIZE * 1.8, 0).rotated(side_angle)
		side_sprite.position = side_position + Global.vector_random(-SIZE / 3, SIZE / 3)

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
