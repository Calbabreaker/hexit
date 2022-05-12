extends Node

var PIECE_SIDES = [SideType.new("triangle"), SideType.new(), SideType.new("circle")]

# Creates a vector with a random xy
static func vector_random(p_min: int, p_max: int) -> Vector2:
	return Vector2(rand_range(p_min, p_max), rand_range(p_min, p_max))

var grid := {}
