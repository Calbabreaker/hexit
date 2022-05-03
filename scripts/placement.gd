extends Node2D

export var piece_prefab: PackedScene

export var score_label_path: NodePath
onready var score_label = get_node(score_label_path)

var grid := {}
var score := 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_click"):
		var piece = piece_prefab.instance()
		var hex_pos = Piece.pixel_to_hex(get_local_mouse_position())
		piece.position = Piece.hex_to_pixel(hex_pos)
		add_child(piece)
		grid[hex_pos] = piece
		
		set_score(score + 1)
		
func set_score(new_score):
	score = new_score
	score_label.text = "Score: %d" % score
