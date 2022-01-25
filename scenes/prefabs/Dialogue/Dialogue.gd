extends Control

export var dialogue_path = "res://res/dialogue/End - auto.csv"
onready var dialogue_resource = load(dialogue_path)

var _current_event = -1
var _left_character_sprite = null
var _right_character_sprite = null

onready var label = $ColorRect/Label
onready var texture_character_left = $CharacterLeft
onready var texture_character_right = $CharacterRight

func _ready():
	_proceed_dialogue()

func _process(delta):
	if Input.is_action_just_pressed("F5"):
		_proceed_dialogue()

func _proceed_dialogue():
	_current_event += 1
	var number_of_dialogue_events = dialogue_resource.events.size()
	if _current_event >= number_of_dialogue_events:
		queue_free()
	else:
		_process_dialogue_event(dialogue_resource.events[_current_event])

func _process_dialogue_event(event):
	if event.type == TootlDialogue.EVENT_MESSAGE:
		label.text = event.data
		return
	elif event.type == TootlDialogue.EVENT_LEFT_SPRITE:
		texture_character_left.texture = load("res://res/textures/dialogue/" + event.data + ".png")
	elif event.type == TootlDialogue.EVENT_RIGHT_SPRITE:
		texture_character_right.texture = load("res://res/textures/dialogue/" + event.data + ".png")
	elif event.type == TootlDialogue.EVENT_SCRIPT:
		GameManager.ExecuteWrenScript(event.data)
	elif event.type == TootlDialogue.EVENT_SNIPPET:
		GameManager.ExecuteWrenSnippet(event.data)
	_proceed_dialogue()
