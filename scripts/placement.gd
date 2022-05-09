extends Node2D

export var piece_prefab: PackedScene
export var score_label_path: NodePath
onready var score_label = get_node(score_label_path)
onready var tween := $Tween

var grid := {}
var score: int
var ghost_piece: Node
var mouse_hex_pos: Vector2

func _ready() -> void:
	set_ghost_piece()
	set_score(0)
	
func _process(delta: float) -> void:
	# Make the ghost piece follow the mouse
	mouse_hex_pos = Piece.pixel_to_hex(get_local_mouse_position())
	ghost_piece.position = Piece.hex_to_pixel(mouse_hex_pos)
	ghost_piece.modulate.r = 10 if grid.has(mouse_hex_pos) else 1 # Redden sprite when piece already exists there

func _input(event: InputEvent) -> void:
	# If the mouse is pressed and a piece hasn't been placed at the position yet
	if event.is_action_pressed("ui_click") && !grid.has(mouse_hex_pos):
		# Reset the ghost piece and put it inside the grid
		tween.remove(ghost_piece)
		ghost_piece.modulate.a = 1
		grid[mouse_hex_pos] = ghost_piece
		set_ghost_piece()
			
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
