extends Spatial

onready var bowling_points_manager = $UIViewport/BowlingUI
onready var hit_timer = $HitTimer
onready var screen_timer = $ScreenTimer
onready var bowling_ball = preload("res://scenes/prefabs/Bowling/Ball/BowlingBall.tscn")
onready var throw_arrow = $ThrowArrow
onready var throw_arrow_camera_position = $ThrowArrow/ThrowArrowCameraPosition
onready var view_camera_position = $ViewPosition
onready var points_camera_position = $PointsPosition
onready var bowling_balls = $BowlingBalls
onready var minigame_camera = $Camera

export var throw_power = 50
var throw_direction = Vector3(-1, 0, 0)

enum BowlingMinigameState {
	AIM,
	YAW,
	ROLLING,
	HIT,
	SCREEN,
	END
}

var current_state = BowlingMinigameState.AIM

func activate():
	visible = true
	$Camera.current = true

func throw_ball():
	var bowling_ball_instance = bowling_ball.instance()
	bowling_ball_instance.translation = $ThrowArrow.translation
	bowling_ball_instance.translation.y += 1
	$BowlingBalls.add_child(bowling_ball_instance)
	bowling_ball_instance.apply_impulse(Vector3(0, 0, 0), throw_direction * throw_power)
	current_state = BowlingMinigameState.ROLLING
	
	throw_arrow.get_node("ThrowArrowPivot").look_at(throw_arrow.global_transform.origin + Vector3(-1, 0, 0), Vector3.UP)

var hit_timer_active = false
var screen_timer_active = false
var t = 0
func _process(delta):
	t += delta
	
	if current_state == BowlingMinigameState.AIM:
		throw_arrow.transform.origin.z = cos(t) * 1.75
		minigame_camera.global_transform.origin = throw_arrow_camera_position.global_transform.origin
		minigame_camera.look_at(Vector3(-28.481, 0, -1), Vector3.UP)
		minigame_camera.fov = 70
		if Input.is_action_just_pressed("interact"):
			current_state = BowlingMinigameState.YAW
	elif current_state == BowlingMinigameState.YAW:
		throw_direction.z = sin(t*(82/60)) * 0.5
		throw_arrow.get_node("ThrowArrowPivot").look_at(throw_arrow.global_transform.origin + throw_direction, Vector3.UP)
		if Input.is_action_just_pressed("interact"):
			throw_ball()
	elif current_state == BowlingMinigameState.ROLLING:
		if bowling_balls.get_children().size() > 0:
			minigame_camera.global_transform.origin = view_camera_position.global_transform.origin
			minigame_camera.look_at(bowling_balls.get_children()[0].global_transform.origin, Vector3.UP)
			minigame_camera.fov = minigame_camera.fov - (minigame_camera.fov - 10) * 0.25 * delta
		else:
			current_state = BowlingMinigameState.HIT
	elif current_state == BowlingMinigameState.HIT:
		if not hit_timer_active:
			hit_timer.start()
			hit_timer_active = true
	elif current_state == BowlingMinigameState.SCREEN:
		if not screen_timer_active:
			screen_timer.start()
			screen_timer_active = true
		minigame_camera.global_transform.origin = points_camera_position.global_transform.origin
		minigame_camera.look_at(minigame_camera.global_transform.origin + Vector3(-1, 0, -0.5), Vector3.UP)
		minigame_camera.fov = 70
		
		
	if Input.is_action_just_pressed("fps_jump"):
		activate()


func _on_HitTimer_timeout():
	hit_timer_active = false
	var num_pins_to_clean = 0
	for pins in $BowlingPins/Pins.get_children():
		if pins.clean():
			num_pins_to_clean += 1
	bowling_points_manager.add_pins_to_frame(num_pins_to_clean)
	current_state = BowlingMinigameState.SCREEN


func _on_ScreenTimer_timeout():
	screen_timer_active = false
	current_state = BowlingMinigameState.AIM
	
	if bowling_points_manager.is_next_shot_new_frame():
		bowling_points_manager.next_frame()
		$BowlingPins.reset_pins()
	
	if bowling_points_manager.game_is_end():
		print("GG")
		current_state = BowlingMinigameState.END
