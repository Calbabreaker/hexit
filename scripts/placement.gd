extends Node2D

export var piece_prefab: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_click"):
		var piece = piece_prefab.instance()
		var hex_pos = Piece.pixel_to_hex(get_local_mouse_position())
		print(hex_pos)
		piece.position = Piece.hex_to_pixel(hex_pos)
		add_child(piece)
