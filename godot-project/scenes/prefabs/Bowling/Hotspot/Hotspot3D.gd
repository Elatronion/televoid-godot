extends Area

signal interact

export var action_name = "Bowling Alley"

func interact():
	emit_signal("interact")
