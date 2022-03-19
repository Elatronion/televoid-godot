extends Spatial



func _on_PlantHotspot3D_interact():
	GameManager.LoadDialogue("res/dialogue/Bowling - Plant.csv")


func _on_ExitHotspot3D_interact():
	get_tree().quit()


func _on_StrangeBrickWallHotspot3D_interact():
	pass # Replace with function body.
