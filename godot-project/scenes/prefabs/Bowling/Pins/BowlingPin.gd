extends RigidBody

var hit = false

func clean():
	if hit:
		queue_free()

func _process(delta):
	if global_transform.origin.y < 0.2:
		hit = true
