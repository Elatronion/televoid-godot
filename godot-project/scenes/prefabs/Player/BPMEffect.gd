extends AnimatedSprite

onready var timer = $Timer
onready var neon_effect = preload("res://scenes/prefabs/Player/NeonEffect.tscn")

func _on_Timer_timeout():
	var neon_effect_instance = neon_effect.instance()
	neon_effect_instance.position = get_global_position()
	neon_effect_instance.animation = animation
	neon_effect_instance.frame = frame
	neon_effect_instance.flip_h = flip_h
	get_tree().root.add_child(neon_effect_instance)
