extends Node2D

onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_finished")
	
	var animation = animation_player.get_animation("IMV Animation")
	var player = get_node(GameManager.player_path)
	
	if not player:
		return
	var x = player.global_position.x
	var y = player.global_position.y
	
	var position_x_track_index = animation.find_track(GameManager.player_camera_path + ":global_position:x")
	animation.track_insert_key(position_x_track_index, 0, x)
	var position_y_track_index = animation.find_track(GameManager.player_camera_path + ":global_position:y")
	animation.track_insert_key(position_y_track_index, 0, y)

func _process(delta):
	GameManager.SetState(GameManager.GameState.IMV)
	global_position.x = get_viewport().size.x / 2
	global_position.y = get_viewport().size.y / 2

func _on_AnimationPlayer_finished(anim_name):
	queue_free()
