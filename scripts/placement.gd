extends Node2D

export var piece_prefab: PackedScene
export var score_label_path: NodePath
onready var score_label = get_node(score_label_path)
export var remaining_label_path: NodePath
onready var remaining_label = get_node(remaining_label_path)
onready var tween := $Tween

var score: int
var ghost_piece: Node
var mouse_hex_pos: Vector2
var remaining: int

func _ready() -> void:
	set_ghost_piece()
	set_score(0)
	set_remaining(10)
	
func _process(delta: float) -> void:
	# Make the ghost piece follow the mouse
	mouse_hex_pos = Piece.pixel_to_hex(get_local_mouse_position())
	ghost_piece.position = Piece.hex_to_pixel(mouse_hex_pos)
	ghost_piece.modulate.r = 1 if can_place_piece(mouse_hex_pos) else 10 # Redden sprite when can't place

func _input(event: InputEvent) -> void:
	# If the mouse is pressed and can place a piece there
	if event.is_action_pressed("ui_click") && can_place_piece(mouse_hex_pos):
		# Reset the ghost piece and put it inside the grid
		tween.remove(ghost_piece)
		ghost_piece.modulate.a = 1
		Global.grid[mouse_hex_pos] = ghost_piece
		
		# Calculate score and pieces remaining
		var prev_score = score
		ghost_piece.loop_through_sides(funcref(self, "calc_connection_score"), mouse_hex_pos)
		var pieces_added = floor((score - prev_score) / 200)
		set_remaining(remaining + pieces_added - 1)
		
		set_ghost_piece()

func calc_connection_score(side: SideType, touching_side: SideType):
	if side == touching_side:
		set_score(score + 100)
	
# Checks if hex_pos is not on a piece
func can_place_piece(hex_pos: Vector2) -> bool:
	return !Global.grid.has(mouse_hex_pos) and remaining > 0

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

func set_remaining(new_remaining):
	remaining = new_remaining
	remaining_label.text = "Remaining: %d" % remaining
