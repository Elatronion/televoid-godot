extends Spatial

signal activated
var active = false

func _on_Hotspot3D_interact():
	if not active:
		$AnimationPlayer.play("Switch")

func _on_AnimationPlayer_animation_finished(anim_name):
	active = true
	emit_signal("activated")
