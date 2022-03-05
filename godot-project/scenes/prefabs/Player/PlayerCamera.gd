extends Camera2D



func _process(delta):
	offset_h = lerp(-0.5, 0.5, get_viewport().get_mouse_position().x / get_viewport_rect().size.x)
	offset_v = lerp(-0.5, 0.5, get_viewport().get_mouse_position().y / get_viewport_rect().size.y)
