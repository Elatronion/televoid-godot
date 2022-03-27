extends CanvasLayer

export var current_song_by_artist = ""
export var current_song = ""
export var current_artist = ""

export var active_x_offset = 0
export var inactive_x_offset = -450

var desired_x_offset = inactive_x_offset

onready var radio_text = $Label
onready var radio_timer = $Timer
onready var radio_bgm = $AudioStreamPlayerBGM
onready var radio_voice = $AudioStreamPlayerVoice
onready var radio_audio_fade = $AudioStreamPlayerBGM/AudioFade

func _update_label():
	radio_text.text = current_song + "\nby: " + current_artist

func _ready():
	_update_label()
	GameManager.connect("play_bgm", self, "_play_song")
	GameManager.connect("play_sfx", self, "_play_sound")
	GameManager.connect("play_voice", self, "_play_voice")

func _play_sound(sound):
	var num_of_sfx_players = 5
	for i in range(1, num_of_sfx_players+1):
		var radio_sfx = get_node("AudioStreamPlayerSFX"+str(i))
		if not radio_sfx.playing:
			radio_sfx.stream = load("res://res/audio/sfx/"+sound+".wav")
			radio_sfx.play()
			break

func _play_voice(voice):
	radio_voice.stream = load("res://res/audio/sfx/"+voice+".wav")
	radio_voice.play()

func _process(delta):
	offset.x += (desired_x_offset - offset.x) * 8 * delta

func _play_song(song_by_artist):
	print(song_by_artist)
	var song_artist = song_by_artist.split(" by ", true);
	var song = song_artist[0]
	var artist = "???"
	if song_artist.size() >= 2:
		artist = song_artist[1]
	
	if current_song == "" or current_song == "NULL":
		radio_bgm.stream = load("res://res/audio/bgm/"+song_by_artist+".wav")
		radio_bgm.volume_db = 0
		radio_bgm.play()
	else:
		radio_audio_fade.play("AudioFadeOut")
	
	
	
	radio_timer.start()
	desired_x_offset = active_x_offset
	
	current_song = song
	current_artist = artist
	current_song_by_artist = song_by_artist
	_update_label()

func _on_Timer_timeout():
	desired_x_offset = inactive_x_offset

func _on_AudioFade_animation_finished(anim_name):
	if anim_name == "AudioFadeOut":
		radio_bgm.stream = load("res://res/audio/bgm/" + current_song_by_artist + ".wav")
		radio_bgm.play()
		radio_audio_fade.play("AudioFadeIn")
