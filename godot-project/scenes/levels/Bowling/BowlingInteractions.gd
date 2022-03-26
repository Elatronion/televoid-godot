extends Spatial


func _on_PlantHotspot3D_interact():
	if $BowlingMinigame.super_secret and not GameManager.HasItem("key"):
		GameManager.AddItem("key")
		GameManager.LoadDialogue("res/dialogue/Bowling - hidden.csv")
	else:
		GameManager.LoadDialogue("res/dialogue/Bowling - Plant.csv")

func _on_ExitHotspot3D_interact():
	get_tree().quit()

func _on_StrangeBrickWallHotspot3D_interact():
	if $BowlingMinigame.super_secret:
		if GameManager.HasItem("key"):
			GameManager.LoadScene("res/scenes/museum.tmx")
		else:
			GameManager.LoadDialogue("res/dialogue/Bowling - wall2.csv")
	else:
		GameManager.LoadDialogue("res/dialogue/Bowling - wall1.csv")
