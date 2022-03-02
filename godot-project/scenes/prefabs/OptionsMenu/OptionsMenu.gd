extends CanvasLayer

func _ready():
	pass

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
	$Control.visible = false
