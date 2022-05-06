class_name SideType

var texture: Texture

func _init(asset_name = null) -> void:
	if asset_name != null:
		texture = load("res://assets/%s.svg" % asset_name)
