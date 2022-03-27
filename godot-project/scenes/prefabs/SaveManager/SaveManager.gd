extends CanvasLayer

# Saving logic should be moved here
# instead of being a part of game_manager

func _ready():
	GameManager.connect("save_game", self, "_save_game")

func _save_game():
	$AnimationPlayer.play("Save")
	$Control.visible = true # this is stupid
