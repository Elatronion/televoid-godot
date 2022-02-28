extends Node2D

func _ready():
	GameManager.connect("load_scene", self, "_on_load_scene")

var scene_to_load = ""
func _on_load_scene(scene_str):
	scene_to_load = scene_str
	$TransitionScreen.transition()

func _load_scene(scene_path):
	var scene = load(scene_path)
	var scene_instance = scene.instance()
	scene_instance.set_name("SceneTMX")
	$CurrentScene.get_child(0).free()
	$CurrentScene.add_child(scene_instance)
	
	GameManager.SetState(GameManager.GameState.PLAY)
	
	var players = get_tree().get_nodes_in_group("Player")
	var player_to_keep = null
	print(players.size())
	if players.size() >= 1:
		for player in players:
			if player.previous_scene_that_activates == GameManager.previous_scene:
				player_to_keep = player
				break
		if player_to_keep == null:
			for player in players:
				if player.previous_scene_that_activates == "":
					player_to_keep = player
					break
		for player in players:
			if player != player_to_keep:
				player.queue_free()
		player_to_keep.set_name("Player")
		player_to_keep.get_node("Camera2D").current = true


func _on_TransitionScreen_transitioned():
	_load_scene(scene_to_load)
