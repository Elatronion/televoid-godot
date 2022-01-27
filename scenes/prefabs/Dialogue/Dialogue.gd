extends CanvasLayer

export var dialogue_path = "res://res/dialogue/End - auto.csv"
onready var dialogue_resource = load(dialogue_path)

var _current_event = -1
var _left_character_sprite = null
var _right_character_sprite = null

var _is_finished = false

onready var timer = $Timer
onready var label = $ColorRect/Label
onready var texture_character_left = $CharacterLeftCanvas/CharacterLeft
onready var canvas_character_left = $CharacterLeftCanvas
onready var texture_character_right = $CharacterRightCanvas/CharacterRight
onready var canvas_character_right = $CharacterRightCanvas
onready var dialogue_box = $ColorRect

var _active_sprite_y = 0
var _active_modulate_a = 1
var _inactive_sprite_y = 100
var _inactive_modulate_a = 0.5

var _finish_y = 750

var interpolate_speed = 15
var _left_character_desired_y = _active_sprite_y
var _left_character_modulate_a = 1
var _right_character_desired_y = _active_sprite_y
var _right_character_modulate_a = 1

var _mouse_hover = false

func _ready():
	_proceed_dialogue()
	GameManager.SetState(GameManager.GameState.DIALOGUE)

func _process(delta):
	if Input.is_action_just_pressed("progress_dialogue") or (_mouse_hover and Input.is_action_just_pressed("interact")):
		_proceed_dialogue()
	_animate_sprites(delta)

func _animate_sprites(delta):
	if _is_finished:
		dialogue_box.modulate.a += (0 - dialogue_box.modulate.a) * interpolate_speed * delta
	canvas_character_left.offset.y += (_left_character_desired_y - canvas_character_left.offset.y) * interpolate_speed * delta
	texture_character_left.modulate.a += (_left_character_modulate_a - texture_character_left.modulate.a) * interpolate_speed * delta
	canvas_character_right.offset.y += (_right_character_desired_y - canvas_character_right.offset.y) * interpolate_speed * delta
	texture_character_right.modulate.a += (_right_character_modulate_a - texture_character_right.modulate.a) * interpolate_speed * delta

func _proceed_dialogue():
	_current_event += 1
	var number_of_dialogue_events = dialogue_resource.events.size()
	if _current_event >= number_of_dialogue_events:
		GameManager.SetState(GameManager.GameState.PLAY)
		timer.start()
		label.visible = false
		_is_finished = true
		interpolate_speed = 5
		_left_character_desired_y = _finish_y
		_left_character_modulate_a = 0
		_right_character_desired_y = _finish_y
		_right_character_modulate_a = 0
	else:
		_process_dialogue_event(dialogue_resource.events[_current_event])

func _process_dialogue_event(event):
	if event.type == TootlDialogue.EVENT_MESSAGE:
		label.text = event.data
		return
	elif event.type == TootlDialogue.EVENT_LEFT_SPRITE:
		texture_character_left.texture = load("res://res/textures/dialogue/" + event.data + ".png")
		_left_character_desired_y = _active_sprite_y
		_left_character_modulate_a = _active_modulate_a
		_right_character_desired_y = _inactive_sprite_y
		_right_character_modulate_a = _inactive_modulate_a
	elif event.type == TootlDialogue.EVENT_RIGHT_SPRITE:
		texture_character_right.texture = load("res://res/textures/dialogue/" + event.data + ".png")
		_left_character_desired_y = _inactive_sprite_y
		_left_character_modulate_a = _inactive_modulate_a
		_right_character_desired_y = _active_sprite_y
		_right_character_modulate_a = _active_modulate_a
	elif event.type == TootlDialogue.EVENT_SCRIPT:
		GameManager.ExecuteWrenScript(event.data)
	elif event.type == TootlDialogue.EVENT_SNIPPET:
		GameManager.ExecuteWrenSnippet(event.data)
	_proceed_dialogue()


func _on_ColorRect_mouse_entered():
	_mouse_hover = true

func _on_ColorRect_mouse_exited():
	_mouse_hover = false


func _on_Timer_timeout():
	queue_free()
