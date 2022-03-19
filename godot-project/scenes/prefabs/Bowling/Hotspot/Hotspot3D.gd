extends Area

signal interact

export var action_name = "Play Bowling"

func interact():
	emit_signal("interact")
