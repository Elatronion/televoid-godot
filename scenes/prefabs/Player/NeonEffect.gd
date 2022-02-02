extends AnimatedSprite

func _ready():
	var tween = $Tween
	tween.interpolate_property(self, "modulate:a",
	1, 0, 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	queue_free()
