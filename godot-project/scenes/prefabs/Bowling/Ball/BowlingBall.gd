extends RigidBody

func _process(delta):
	if global_transform.origin.y < 0:
		queue_free()
