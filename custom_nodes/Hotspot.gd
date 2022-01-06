extends Area2D
class_name Hotspot

export var wren_snippet = ""
export var wren_script = ""
export var item_string = ""
export var auto_exec = false
export var wireless = false
export var is_item = false

export var width = 0
export var height = 0

var mouse_hovering = false

func execute():
	if is_item:
		GameManager.AddItem(item_string)
		queue_free()
	elif wren_snippet.length() != 0:
		GameManager.ExecuteWrenSnippet(wren_snippet)
	elif wren_script.length() != 0:
		GameManager.ExecuteWrenScript(wren_snippet)
	else:
		print("Hotspot: Execution unkonwn!")

func _on_Hotspot_mouse_entered() -> void:
	mouse_hovering = true

func _on_Hotspot_mouse_exited() -> void:
	mouse_hovering = false

func _ready():
	connect("mouse_entered", self, "_on_Hotspot_mouse_entered")
	connect("mouse_exited", self, "_on_Hotspot_mouse_exited")
	
	if auto_exec:
		execute()
	if is_item and GameManager.HasItem(item_string):
		queue_free()

func _process(delta):
	if mouse_hovering and Input.is_action_just_pressed("interact"):
		if wireless:
			execute()
		GameManager.emit_signal("hotspot_interaction", self)
