extends Sprite

func _ready():
	# This gets reset by godot, annoyingly
	texture.flags = texture.FLAG_REPEAT
