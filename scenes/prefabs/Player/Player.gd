extends KinematicBody2D

export var previous_scene_that_activates = ""
export var face_left_on_start = false

enum State {
	IDLE,
	WALKING,
	INTERACTING
}

var current_state = State.IDLE

var destination : Vector2 = Vector2.ZERO
var max_speed = 50

var current_hotspot = null

onready var aniamted_sprite = $AnimatedSprite

func SetState(state):
	if current_state != state:
		match state:
			State.IDLE:
				aniamted_sprite.animation = "idle"
				aniamted_sprite.speed_scale = 1
				aniamted_sprite.play()
			State.WALKING:
				aniamted_sprite.animation = "walk"
				aniamted_sprite.speed_scale = 1
				aniamted_sprite.play()
			State.INTERACTING:
				aniamted_sprite.animation = "interact"
				aniamted_sprite.speed_scale = 1
				aniamted_sprite.play()
		current_state = state

func Walk(delta):
	var vec_to_destination = (destination - global_position) * 10
	vec_to_destination.x = max(min(vec_to_destination.x, max_speed), -max_speed)
	vec_to_destination.y = 0
	move_and_slide(vec_to_destination)
	
	var current_speed_ratio = abs(vec_to_destination.x) / max_speed
	aniamted_sprite.flip_h = vec_to_destination.x < 0
	aniamted_sprite.speed_scale = current_speed_ratio
	
	if abs(vec_to_destination.x) < 5:
		if current_hotspot == null:
			SetState(State.IDLE)
		else:
			SetState(State.INTERACTING)

func Interact(delta):
	if current_hotspot != null and aniamted_sprite.frame == 2:
		current_hotspot.execute()
		current_hotspot = null
	if aniamted_sprite.frame == 7:
		SetState(State.IDLE)

func _ready():
	$AnimatedSprite.flip_h = face_left_on_start
	GameManager.connect("hotspot_interaction", self, "_on_Hotspot_interaction")

func _process(delta):
	if GameManager.game_state != GameManager.GameState.IMV:
		$Camera2D.position.x = 0
		$Camera2D.position.y = 0
		$Camera2D.zoom.x += (GameManager.default_zoom - $Camera2D.zoom.x) * 5 * delta
		$Camera2D.zoom.y += (GameManager.default_zoom - $Camera2D.zoom.y) * 5 * delta
		#$Camera2D.zoom = Vector2(GameManager.default_zoom, GameManager.default_zoom)
	
	_processFloor(delta)
	
	if GameManager.game_state != GameManager.GameState.PLAY:
		return
	
	_processControls()
	match current_state:
		State.IDLE:
			pass
		State.WALKING:
			Walk(delta)
		State.INTERACTING:
			Interact(delta)

func _floor_height_at_x(x):
	var height = 0
	
	var floors = get_tree().get_nodes_in_group("Floor")
	if not floors.empty():
		var floor_polygon = floors[0].get_polygon()
		var floor_position = floors[0].global_position
		for i in range(floor_polygon.size()-1):
			var current_floor_node_position = floor_position + floor_polygon[i]
			var next_floor_node_position = floor_position + floor_polygon[i+1]
			if 	(
				current_floor_node_position.x < x and
				next_floor_node_position.x > x
				):
					var ratio = (x - current_floor_node_position.x) / (next_floor_node_position.x - current_floor_node_position.x)
					height = lerp(current_floor_node_position.y, next_floor_node_position.y, ratio);
					break
		
		# LEFT/RIGHT FLOOR COLLISION #
#		var margin = 1
#		var left_most_x = floor_polygon[0].x + margin
#		var right_most_x = floor_polygon[floor_polygon.size()-1].x - margin
#		if x < left_most_x:
#			global_position.x = left_most_x
#			SetState(State.IDLE)
#		if x > right_most_x:
#			global_position.x = right_most_x
#			SetState(State.IDLE)
	
	return height

func _processFloor(delta):
	var floor_height = _floor_height_at_x(global_position.x)
	global_position.y = floor_height

var _just_clicked_hotspot = false
func _processControls():
	if Input.is_action_just_pressed("interact") and not _just_clicked_hotspot:
		var mouse_position = get_viewport().get_mouse_position()
		mouse_position -= Vector2(get_viewport_rect().size.x/2.0, get_viewport_rect().size.y/2.0)
		destination = global_position + mouse_position*0.25
		SetState(State.WALKING)
		current_hotspot = null
	_just_clicked_hotspot = false

func _on_Hotspot_interaction(hotspot):
	_just_clicked_hotspot = true
	if hotspot.wireless:
		return
	current_hotspot = hotspot
	destination = hotspot.global_position + Vector2(hotspot.width/2, hotspot.height/2)
	SetState(State.WALKING)
