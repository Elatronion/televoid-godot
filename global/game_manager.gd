extends Node

signal load_scene(scene)
signal hotspot_interaction(hotspot)
signal play_bgm(song_by_artist)

const og_tootl_camera_z_distance = 100 * 4

const default_zoom = 0.25
const player_path = "/root/SceneManager/CurrentScene/SceneTMX/Player"
const player_camera_path = "/root/SceneManager/CurrentScene/SceneTMX/Player/Camera2D"

enum GameState {IMV, DIALOGUE, PLAY}

var game_state = GameState.PLAY

var previous_scene = ""
var current_scene = ""
var items = [null, null, null, null, null, null, null, null, null, null]

func _process(delta):
	if Input.is_action_just_pressed("F1"):
		LoadDialogue("res/dialogue/Arcade - Giftshop complete.csv")
		#PlayBGM("sad again by brutalmoose")
	if Input.is_action_just_pressed("F2"):
		LoadIMV("res://res/imv/HUB - Look Up.imv")
	if Input.is_action_just_pressed("F3"):
		LoadScene("res/scenes/HUB/HUB.tmx")
	if Input.is_action_just_pressed("F4"):
		LoadScene("res/scenes/arcade.tmx")

func SetState(state):
	game_state = state

func AddItem(item_string):
	for i in range(0, 10):
		if items[i] == null:
			items[i] = item_string
			return

func HasItem(item_string):
	for i in range(0, 10):
		if items[i] == item_string:
			return true
	return false

func LoadScene(scene):
	previous_scene = current_scene
	current_scene = scene
	self.emit_signal("load_scene", "res://"+scene)

func LoadIMV(imv_path):
	var imv_resource = load(imv_path)
	var imv_instance = imv_resource.instance()
	self.add_child(imv_instance)

func LoadDialogue(dialogue_path):
	var dialogue = load("res://scenes/prefabs/Dialogue/Dialogue.tscn")
	var dialogue_instance = dialogue.instance()
	dialogue_instance.dialogue_path = "res://" + dialogue_path
	self.add_child(dialogue_instance)
	

func PlayBGM(song_by_artist):
	self.emit_signal("play_bgm", song_by_artist)

func ExecuteWrenSnippet(wren_snippet):
	print("Executing Wren Snippet '%s'" % wren_snippet)

func ExecuteWrenScript(wren_script):
	print("Executing Wren Script '%s'" % wren_script)
