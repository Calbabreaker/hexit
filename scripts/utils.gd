class_name Utils

"""
func axial_round(hex: Vector2) -> Vector2:
	var grid = hex.round()
	hex -= grid
	var dx = round(hex.x + hex.y / 2) * (x*x >= y*y)
	var dy = round(hex.y + hex.x / 2) * (x*x < y*y)
	return grid + Vector2(dx, dy)
"""

const HEXAGON_SIZE := 64

# Converts pixel coordinates to hexagon grid coordinates
func pixel_to_hex(pixel: Vector2) -> Vector2:
	var q = (2/3 * pixel.x) / HEXAGON_SIZE
	var r = (-1/3 * pixel.x  +  sqrt(3)/3 * pixel.y) / HEXAGON_SIZE
	return Vector2(q, r)
