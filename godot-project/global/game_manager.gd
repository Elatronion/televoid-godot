extends Node

signal load_scene(scene)
signal hotspot_interaction(hotspot)
signal play_bgm(song_by_artist)
signal play_sfx(sound)
signal play_voice(voice)
signal save_game()

const og_tootl_camera_z_distance = 100 * 4

const default_zoom = 0.25
const player_path = "/root/SceneManager/CurrentScene/SceneTMX/Player"
const player_camera_path = "/root/SceneManager/CurrentScene/SceneTMX/Player/Camera2D"

enum GameState {IMV, DIALOGUE, PLAY, MINIGAME, PAUSE}

var game_state = GameState.PLAY

var previous_scene = ""
var current_scene = ""
var items = [null, null, null, null, null, null, null, null, null, null]

const default_master = 0
const default_bgm = -12
const default_sfx = -5
const default_voice = -10
var audio_master = 0
var audio_bgm = -12
var audio_sfx = -5
var audio_voice = -10

var mouse_cursor = load("res://res/textures/GUI/Cursor_Normal.bmp")
var mouse_point = load("res://res/textures/GUI/Cursor_Point.bmp")
var mouse_walk = load("res://res/textures/GUI/Cursor_Walk.bmp")
var mouse_test = load("res://res/textures/GUI/Cursor_Walk.bmp")

#onready var tootlwren = preload("res://gdnative/tootlwren.gdns").new()
var tootlwren = null
var minigame_tootlwren = null
func _ready():
	LoadOptions()
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
	
	set_mouse_normal()
	Input.set_custom_mouse_cursor(mouse_cursor, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(mouse_point, Input.CURSOR_POINTING_HAND)

func set_mouse_normal():
	Input.set_custom_mouse_cursor(mouse_cursor)
func set_mouse_point():
	Input.set_custom_mouse_cursor(mouse_point, 0, Vector2(5, 1))
func set_mouse_walk():
	Input.set_custom_mouse_cursor(mouse_walk)

func _process(delta):
	if game_state != GameState.PAUSE:
		SetState(GameState.PLAY)
	if Input.is_action_just_pressed("F1"):
		AddItem("VHS")
		AddItem("helmet")
		AddItem("brutal moose")
		#LoadMinigame("res/scripts/minigames/main_menu.wren", true)
		#PlayBGM("sad again by brutalmoose")
	if Input.is_action_just_pressed("F2"):
		SaveGame()
	if Input.is_action_just_pressed("F3"):
		LoadGame()
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
	SaveGame()
	self.emit_signal("load_scene", "res://"+scene)

func LoadIMV(imv_path):
	var imv_resource = load(imv_path)
	var imv_instance = imv_resource.instance()
	self.get_node("/root/SceneManager/CurrentScene").get_child(0).call_deferred("add_child", imv_instance)
	self.get_node("/root/SceneManager/CurrentScene").get_child(0).call_deferred("move_child", imv_instance, 0)

var dialogue = preload("res://scenes/prefabs/Dialogue/Dialogue.tscn")
func LoadDialogue(dialogue_path):
	var dialogue_instance = dialogue.instance()
	dialogue_instance.dialogue_path = "res://" + dialogue_path
	self.add_child(dialogue_instance)
	self.move_child(dialogue_instance, dialogue_instance.get_index()-1)

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
	minigame_scene_instance.get_node("Button").visible = can_exit

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

func VolumeSetMaster(db):
	audio_master = db
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
func VolumeSetBGM(db):
	audio_bgm = db
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), db)
func VolumeSetSFX(db):
	audio_sfx = db
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)
func VolumeSetVoice(db):
	audio_bgm = db
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), db)
func reset_audio_defaults():
	GameManager.VolumeSetMaster(default_master)
	GameManager.VolumeSetBGM(default_bgm)
	GameManager.VolumeSetSFX(default_sfx)
	GameManager.VolumeSetVoice(default_voice)

var SaveGameData = {
	scene="",
	items=[null, null, null, null, null, null, null, null, null, null]
}

func SaveGame():
	if current_scene == "res/scenes/End/End.tmx" or current_scene == "res/scenes/credits.tmx" or current_scene == "res/scenes/main_menu.tmx" or current_scene == "res/scenes/settings_menu.tmx":
		return
	var dir = Directory.new()
	if !dir.dir_exists("user://Saves"):
		dir.open("user://")
		dir.make_dir("user://Saves")
	var save_game = File.new()
	save_game.open("user://Saves/save.sve", File.WRITE)
	var data = SaveGameData
	data.scene = current_scene
	data.items = items
	save_game.store_line(JSON.print(data))
	save_game.close()
	self.emit_signal("save_game")

func LoadGame():
	var load_game = File.new()
	if !load_game.file_exists("user://Saves/save.sve"):
		LoadScene("res/scenes/intro.tmx")
		return
	load_game.open("user://Saves/save.sve", File.READ)
	var content = load_game.get_as_text()
	print(content)
	var game_data = JSON.parse(content).result
	items = game_data["items"]
	LoadScene(game_data["scene"])
	load_game.close()

var OptionsSaveData = {
	audio_master = 0,
	audio_bgm = -12,
	audio_sfx = -5,
	audio_voice = -10
}

func LoadOptions():
	var file = File.new()
	if !file.file_exists("user://options.json"):
		return
	file.open("user://options.json", File.READ)
	var content = file.get_as_text()
	var option_data = JSON.parse(content).result
	audio_master = option_data["audio_master"]
	audio_bgm = option_data["audio_bgm"]
	audio_sfx = option_data["audio_sfx"]
	audio_voice = option_data["audio_voice"]
	file.close()

func SaveOptions():
	var file = File.new()
	file.open("user://options.json", File.WRITE)
	var data = OptionsSaveData
	OptionsSaveData.audio_master = audio_master
	OptionsSaveData.audio_bgm = audio_bgm
	OptionsSaveData.audio_sfx = audio_sfx
	OptionsSaveData.audio_voice = audio_voice
	file.store_line(JSON.print(data))
	file.close()
