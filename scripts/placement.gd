extends Node2D

# Get required nodes in the scene
export var piece_prefab: PackedScene
export var text_popup_prefab: PackedScene
export var score_label_path: NodePath
onready var score_label = get_node(score_label_path)
export var remaining_label_path: NodePath
onready var remaining_label = get_node(remaining_label_path)
export var lose_panel_path: NodePath
onready var lose_panel = get_node(lose_panel_path)
onready var tween := $Tween

var score: int
var ghost_piece: Node
var mouse_hex_pos: Vector2
var remaining: int

func _ready() -> void:
	# Set the default values 
	set_score(0)
	set_remaining(20)
	set_ghost_piece()
	
func _process(delta: float) -> void:
	# If the ghost piece is not here then do nothing
	if ghost_piece == null:
		return
		
	# Make the ghost piece follow the mouse
	mouse_hex_pos = Piece.pixel_to_hex(get_local_mouse_position())
	ghost_piece.position = Piece.hex_to_pixel(mouse_hex_pos)
	ghost_piece.modulate.r = 1 if can_place_piece(mouse_hex_pos) else 10 # Redden sprite when can't place

func _unhandled_input(event: InputEvent) -> void:
	# If the mouse is pressed and can place a piece there
	if event.is_action_released("ui_click") && can_place_piece(mouse_hex_pos):
		# Reset the ghost piece and put it inside the grid
		tween.remove(ghost_piece)
		ghost_piece.modulate.a = 1
		Global.grid[mouse_hex_pos] = ghost_piece
		
		# Calculate score and pieces remaining
		var matching_sides = get_matching_sides(ghost_piece, mouse_hex_pos)
		
		# Exponential growth of score rewarded for # of matching sides (0 -> 0, 1 -> 100, 2 -> 200, 3 -> 400, 4 -> 800) 
		var score_diff = 0 if matching_sides == 0 else pow(2, (matching_sides - 1)) * 100
		set_score(score + score_diff)
		
		# Order of the increase in piece added (1 -> 0, 2 -> 1, 3 -> 3, 4 -> 5, ...)
		var pieces_to_add =  0 if matching_sides <= 1 else (matching_sides - 2) * 2 + 1
		set_remaining(remaining + pieces_to_add - 1) # Add the number of pieces awarded and take one away
		
		# Only show text if obtained score and/or piece(s)
		var text := ""
		if score_diff > 0:
			text += "+%d" % score_diff
		if pieces_to_add > 0:
			text += "\n+%d piece" % pieces_to_add
		if text != "":
			var text_popup = text_popup_prefab.instance()
			add_child(text_popup)
			text_popup.init(text, ghost_piece.position)
		
		set_ghost_piece()

# Get number of sides the the pieces matches
func get_matching_sides(piece: Piece, piece_hex_pos: Vector2):
	var count := 0
	for i in range(6):
		# Get touching piece
		var touching_piece = Global.grid.get(piece_hex_pos + Piece.SIDE_OFFSETS[i])
		if touching_piece != null:
			# Get touching side
			var touching_side = touching_piece.sides[(i + 3) % 6]
			if piece.sides[i] == touching_side:
				count += 1
	return count
	
# Checks if hex_pos is not on a piece
func can_place_piece(hex_pos: Vector2) -> bool:
	return !Global.grid.has(mouse_hex_pos) and ghost_piece != null

func set_ghost_piece():
	# Don't allow the user to place anymore if no pieces remain
	if remaining == 0:
		ghost_piece = null
		return
	
	# Create an instance of the piece object which will act as a ghost showing where the piece will be placed at
	ghost_piece = piece_prefab.instance()
	add_child(ghost_piece)
	
	# Create the blinking animation by interpolating between different color alphas
	tween.interpolate_property(ghost_piece, "modulate:a", 0.81, 0.4, 0.5, Tween.TRANS_QUAD)
	tween.interpolate_property(ghost_piece, "modulate:a", 0.4, 0.81, 0.5, Tween.TRANS_QUAD, 2, 0.5)
	tween.start()

# These functions down here update the variable as well as the label in the scene asscosiated with them
func set_score(new_score):
	score = new_score
	score_label.text = "Score: %d" % score

func set_remaining(new_remaining):
	remaining = new_remaining
	remaining_label.text = "Remaining: %d" % remaining
	if remaining <= 0:
		remaining_label.hide()
		lose_panel.show()

# When the reset button is pressed reset the grid map and reload the scene
func _on_ResetButton_pressed() -> void:
	Global.grid = {}
	get_tree().change_scene("res://scenes/main.tscn")
