extends RigidBody

func _process(delta):
#	print(global_transform.origin.y)
	if global_transform.origin.y < 0:
		queue_free()
