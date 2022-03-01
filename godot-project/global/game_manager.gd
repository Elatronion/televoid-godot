extends Node

signal load_scene(scene)
signal hotspot_interaction(hotspot)
signal play_bgm(song_by_artist)
signal play_sfx(sound)
signal play_voice(voice)

const og_tootl_camera_z_distance = 100 * 4

const default_zoom = 0.25
const player_path = "/root/SceneManager/CurrentScene/SceneTMX/Player"
const player_camera_path = "/root/SceneManager/CurrentScene/SceneTMX/Player/Camera2D"

enum GameState {IMV, DIALOGUE, PLAY, MINIGAME}

var game_state = GameState.PLAY

var previous_scene = ""
var current_scene = ""
var items = ["helmet", "VHS", "brutal moose", "recipe", null, null, null, null, null, null]

#onready var tootlwren = preload("res://gdnative/tootlwren.gdns").new()
var tootlwren = null
var minigame_tootlwren = null
func _ready():
	tootlwren = load("res://gdnative/tootlwren.gdns").new()
	add_child(tootlwren)
	tootlwren.connect("load_scene", self, "LoadScene")
	tootlwren.connect("load_dialogue", self, "LoadDialogue")
	tootlwren.connect("play_bgm", self, "PlayBGM")
	tootlwren.connect("play_sfx", self, "PlaySFX")
	tootlwren.connect("play_voice", self, "PlayVoice")
	tootlwren.connect("load_imv", self, "LoadIMV")
	tootlwren.connect("load_minigame", self, "LoadMinigame")
	tootlwren.parse_wren_snippet("System.print(\"Hello, GDWren!\")")

func _process(delta):
	GameManager.SetState(GameManager.GameState.PLAY)
	if Input.is_action_just_pressed("F1"):
		AddItem("blow torch")
		#LoadMinigame("res/scripts/minigames/main_menu.wren", true)
		#PlayBGM("sad again by brutalmoose")
	if Input.is_action_just_pressed("F2"):
		#RemoveItem("blow torch")
		LoadIMV("res://res/imv/HUB - Look Up.imv")
	if Input.is_action_just_pressed("F3"):
		LoadScene("res/scenes/HUB/HUB.tmx")
	if Input.is_action_just_pressed("F4"):
		LoadScene("res/scenes/arcade.tmx")
	if Input.is_action_just_pressed("F5"):
		LoadScene("res/scenes/Infinihallway/Infinihallway.tmx")

func GetKey(key_code):
	return GlobalInput.is_key_pressed(key_code)
func GetKeyDown(key_code):
	return GlobalInput.is_key_just_pressed(key_code)
func GetKeyUp(key_code):
	return GlobalInput.is_key_just_released(key_code)
func GetMouse(mouse_button):
	return GlobalInput.is_mouse_pressed(mouse_button)
func GetMouseDown(mouse_button):
	return GlobalInput.is_mouse_just_pressed(mouse_button)
func GetMouseUp(mouse_button):
	return GlobalInput.is_mouse_just_released(mouse_button)
func GetMouseX():
	return GlobalInput.get_mouse_position().x
func GetMouseY():
	return GlobalInput.get_mouse_position().y

func SetState(state):
	game_state = state

func AddItem(item_string):
	for i in range(0, 10):
		if items[i] == item_string:
			return
		if items[i] == null:
			items[i] = item_string
			return

func RemoveItem(item_string):
	for i in range(0, 10):
		if items[i] == item_string:
			items[i] = null
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

var dialogue = preload("res://scenes/prefabs/Dialogue/Dialogue.tscn")
func LoadDialogue(dialogue_path):
	var dialogue_instance = dialogue.instance()
	dialogue_instance.dialogue_path = "res://" + dialogue_path
	self.add_child(dialogue_instance)

var minigame_scene = preload("res://scenes/prefabs/Minigame/Minigame.tscn")
func LoadMinigame(minigame_path, can_exit):
	var minigame_tootlwren = load("res://gdnative/tootlwren.gdns").new()
	var wren_script_resource = load(minigame_path)
	minigame_tootlwren.connect("load_scene", self, "LoadScene")
	minigame_tootlwren.connect("load_dialogue", self, "LoadDialogue")
	minigame_tootlwren.connect("play_bgm", self, "PlayBGM")
	#minigame_tootlwren.connect("play_sfx", self, "PlaySFX")
	minigame_tootlwren.connect("play_voice", self, "PlayVoice")
	minigame_tootlwren.connect("load_imv", self, "LoadIMV")
	minigame_tootlwren.connect("load_minigame", self, "LoadMinigame")
	add_child(minigame_tootlwren)
	
	var minigame_scene_instance = minigame_scene.instance()
	minigame_scene_instance.minigame_tootlwren = minigame_tootlwren
	self.add_child(minigame_scene_instance)
	minigame_scene_instance.init(wren_script_resource.resource_name)

func PlayBGM(song_by_artist):
	self.emit_signal("play_bgm", song_by_artist)
func PlaySFX(sound):
	self.emit_signal("play_sfx", sound)
func PlayVoice(voice):
	self.emit_signal("play_voice", voice)

func ExecuteWrenSnippet(wren_snippet):
	tootlwren.parse_wren_snippet("import \"televoid-core\" for Scene, Inventory, Dialogue, Minigame, Audio, Animation, Character, GameSaver\n" + wren_snippet)

func ExecuteWrenScript(wren_script):
	var wren_script_resource = load(wren_script)
	tootlwren.parse_wren_snippet(wren_script_resource.resource_name)
