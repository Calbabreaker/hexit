extends Node

var PIECE_SIDES = [SideType.new(null), SideType.new("triangle"), SideType.new("circle"), SideType.new("hexagon"), SideType.new("star"), SideType.new("cross")]

var grid := {}

# Creates a vector with xy components random between min and max
static func vector_random(p_min: int, p_max: int) -> Vector2:
	return Vector2(rand_range(p_min, p_max), rand_range(p_min, p_max))
