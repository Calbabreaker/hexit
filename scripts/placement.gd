extends Node2D

const invalid_color := Color(0xff0000ff)

export var piece_prefab: PackedScene
export var score_label_path: NodePath
onready var score_label = get_node(score_label_path)
onready var tween := $Tween

var grid := {}
var score: int
var ghost_piece: Node

func _ready() -> void:
	set_ghost_piece()
	set_score(0)

func _input(event: InputEvent) -> void:
	# If the mouse moved or clicked
	if event is InputEventMouse:
		var hex_pos = Piece.pixel_to_hex(get_local_mouse_position())
			
		# If the mouse is pressed and a piece hasn't been placed at the position yet
		if event.is_action_pressed("ui_click") && !grid.has(hex_pos):
			# Reset the ghost piece and put it inside the grid
			tween.remove(ghost_piece)
			ghost_piece.modulate = Color(0xffffffff)
			grid[hex_pos] = ghost_piece
			set_ghost_piece()
		
		# Make the ghost piece follow the mouse
		# Set down here to ensure the newly created ghost piece is at the mouse
		ghost_piece.position = Piece.hex_to_pixel(hex_pos)
		ghost_piece.modulate = invalid_color if grid.has(hex_pos) else Color.white
			
func set_ghost_piece():
	ghost_piece = piece_prefab.instance()
	add_child(ghost_piece)
	
	# Create the blinking animation by interpolating between different color alphas
	tween.interpolate_property(ghost_piece, "modulate:a", 0.81, 0.4, 0.5, Tween.TRANS_QUAD)
	tween.interpolate_property(ghost_piece, "modulate:a", 0.4, 0.81, 0.5, Tween.TRANS_QUAD, 2, 0.5)
	tween.start()

func set_score(new_score):
	score = new_score
	score_label.text = "Score: %d" % score
