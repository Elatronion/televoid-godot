extends CanvasLayer

onready var menu = $Menu
onready var options_menu = $OptionsMenu/Control
#onready var pause_button = $PauseButton

func _input(event):
	if GameManager.game_state == GameManager.GameState.PLAY and Input.is_action_just_pressed("pause"):
		_pause()
	elif GameManager.game_state == GameManager.GameState.PAUSE and Input.is_action_just_pressed("pause"):
		_resume()

func _pause():
	GameManager.SetState(GameManager.GameState.PAUSE)
	menu.visible = true
#	pause_button.visible = false
	GameManager.PlaySFX("Pause")

func _resume():
	GameManager.SetState(GameManager.GameState.PLAY)
	menu.visible = false
#	pause_button.visible = true
	GameManager.PlaySFX("Resume")

func _on_ButtonResume_pressed():
	_resume()

func _on_ButtonOptions_pressed():
	options_menu.visible = true

func _on_ButtonSave_pressed():
	GameManager.SaveGame()

func _on_ButtonQuit_pressed():
	get_tree().quit()

func _on_Button_pressed():
	get_node(GameManager.player_path).SetState(0) # This isn't a proper fix
	_pause()
