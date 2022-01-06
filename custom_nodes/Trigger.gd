extends Area2D
class_name Trigger

export var wren_snippet = ""
export var wren_script = ""

export var width = 0
export var height = 0

func execute():
	if wren_snippet.length() != 0:
		print("Executing Wren Snippet '%s'" % wren_snippet)
	elif wren_script.length() != 0:
		print("Executing Wren Script '%s'" % wren_script)
	else:
		print("Trigger: Execution unkonwn!")

func _on_Trigger_body_entered(body):
	if body.is_in_group("Player"):
		execute()

func _ready():
	connect("body_entered", self, "_on_Trigger_body_entered")
