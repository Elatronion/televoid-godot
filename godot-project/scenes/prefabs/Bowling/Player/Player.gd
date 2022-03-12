extends KinematicBody

export(float) var walk_speed = 6
export(float) var acceleration = 10
export(float) var gravity = 15
export(float) var mouse_sensitivity = 0.05
export(float) var jump_strength = 6

var velocity = Vector3()
var movement = Vector3()
var direction = Vector3()

var gravity_vec = Vector3()

var jumping: bool = false;

func _physics_process(delta: float) -> void:
	handle_movement_input()
	move(delta)

func handle_movement_input() -> void:
	direction = Vector3.ZERO
	if(Input.is_action_pressed("fps_move_front")):
		direction += -transform.basis.z
	if(Input.is_action_pressed("fps_move_back")):
		direction += transform.basis.z
	if(Input.is_action_pressed("fps_move_left")):
		direction += -transform.basis.x
	if(Input.is_action_pressed("fps_move_right")):
		direction += transform.basis.x
	direction = direction.normalized()
	
	jumping = Input.is_action_just_pressed("fps_jump")

func move(delta: float) -> void:
	velocity = velocity.linear_interpolate(direction * walk_speed, acceleration * delta)
	
	var snap = Vector3.DOWN
	if is_on_floor():
		snap = -get_floor_normal()
		velocity.y = 0
		gravity_vec = Vector3()
		if jumping:
			snap = Vector3()
			gravity_vec.y = jump_strength
	else:
		gravity_vec += Vector3.DOWN * gravity * delta
	
	movement.x = velocity.x
	movement.z = velocity.z
	movement.y = gravity_vec.y
	movement = move_and_slide_with_snap(movement, snap, Vector3.UP, true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		$Camera.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
