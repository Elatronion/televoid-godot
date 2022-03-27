extends Button

func _on_Button_pressed():
	get_parent().queue_free()
