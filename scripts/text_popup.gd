extends Control

onready var tween := $Tween
onready var label := $Label

func init(text: String, p_position: Vector2) -> void:
	label.text = text
	rect_position = p_position
	
	# Make text go up fade away
	tween.interpolate_property(self, "modulate:a", 1, 0, 1)
	tween.interpolate_property(self, "rect_position:y", null, rect_position.y - 30, 1)
	tween.start()

# Destroy itself when animation finsihed
func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	queue_free()
