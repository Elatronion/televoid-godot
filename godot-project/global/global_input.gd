extends Node

var pressed_key_states = {}
var just_pressed_key_states = {}
var just_released_key_states = {}

var pressed_mouse_states = {}
var just_pressed_mouse_states = {}
var just_released_mouse_states = {}

func _process(delta):
	just_pressed_key_states.clear()
	just_released_key_states.clear()
	just_pressed_mouse_states.clear()
	just_released_mouse_states.clear()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if(!is_mouse_pressed(event.button_index)):
				just_pressed_mouse_states[event.button_index] = true
			pressed_mouse_states[event.button_index] = true
		else:
			just_released_mouse_states[event.button_index] = true
			pressed_mouse_states[event.button_index] = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if(!is_key_pressed(event.scancode)):
				just_pressed_key_states[event.scancode] = true
			pressed_key_states[event.scancode] = true
		else:
			just_released_key_states[event.scancode] = true
			pressed_key_states[event.scancode] = false

func is_key_pressed(scancode):
	var key_is_pressed = false
	if pressed_key_states.has(scancode):
		key_is_pressed = pressed_key_states[scancode]
	else:
		key_is_pressed = false
	return key_is_pressed

func is_key_just_pressed(scancode):
	var key_just_pressed = false
	if just_pressed_key_states.has(scancode):
		key_just_pressed = just_pressed_key_states[scancode]
	else:
		key_just_pressed = false
	return key_just_pressed

func is_key_just_released(scancode):
	var key_just_released = false
	if just_released_key_states.has(scancode):
		key_just_released = just_released_key_states[scancode]
	else:
		key_just_released = false
	return key_just_released

func is_mouse_pressed(scancode):
	var mouse_is_pressed = false
	if pressed_mouse_states.has(scancode):
		mouse_is_pressed = pressed_mouse_states[scancode]
	else:
		mouse_is_pressed = false
	return mouse_is_pressed

func is_mouse_just_pressed(scancode):
	var mouse_just_pressed = false
	if just_pressed_mouse_states.has(scancode):
		mouse_just_pressed = just_pressed_mouse_states[scancode]
	else:
		mouse_just_pressed = false
	return mouse_just_pressed

func is_mouse_just_released(scancode):
	var mouse_just_released = false
	if just_released_mouse_states.has(scancode):
		mouse_just_released = just_released_mouse_states[scancode]
	else:
		mouse_just_released = false
	return mouse_just_released

func get_mouse_position():
	var mouse_position = get_viewport().get_mouse_position()
	
	mouse_position.x -= get_viewport().size.x/2
	mouse_position.y -= get_viewport().size.y/2
	mouse_position.y = -mouse_position.y
	return mouse_position
