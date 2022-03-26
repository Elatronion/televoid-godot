extends Sprite3D

export(String, MULTILINE) var text = "Hello, World!"

var just_interacted = false

func _on_Hotspot3D_interact():
	$Control/Panel/Label.text = text
	$Control.visible = true
	just_interacted = true


func _process(delta):
	if $Control.visible:
		GameManager.SetState(GameManager.GameState.DIALOGUE)
		if not just_interacted and Input.is_action_just_pressed("interact"):
			$Control.visible = false
		just_interacted = false
