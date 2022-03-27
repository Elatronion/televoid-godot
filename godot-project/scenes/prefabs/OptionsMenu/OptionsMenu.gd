extends CanvasLayer

export var full_menu = false

func _ready():
	_set_slider_values()
	if full_menu:
		$Control.visible = true

func _process(delta):
	if full_menu:
		GameManager.SetState(GameManager.GameState.PAUSE)

func _set_slider_values():
	$Control/ColorRect/VBoxContainer/HSliderMasterVolume.value = GameManager.audio_master
	$Control/ColorRect/VBoxContainer/HSliderBGMVolume.value = GameManager.audio_bgm
	$Control/ColorRect/VBoxContainer/HSliderSFXVolume.value = GameManager.audio_sfx
	$Control/ColorRect/VBoxContainer/HSliderVoiceVolume.value = GameManager.audio_voice

func _on_HSliderMasterVolume_value_changed(value):
	GameManager.VolumeSetMaster(value)


func _on_HSliderBGMVolume_value_changed(value):
	GameManager.VolumeSetBGM(value)


func _on_HSliderSFXVolume_value_changed(value):
	GameManager.VolumeSetSFX(value)


func _on_HSliderVoiceVolume_value_changed(value):
	GameManager.VolumeSetVoice(value)


func _on_ButtonReset_pressed():
	GameManager.reset_audio_defaults()
	_set_slider_values()


func _on_Exit_pressed():
	GameManager.SaveOptions()
	if full_menu:
		GameManager.LoadScene("res/scenes/main_menu.tmx")
	else:
		$Control.visible = false
