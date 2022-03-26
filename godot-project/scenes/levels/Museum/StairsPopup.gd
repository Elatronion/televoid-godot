extends MeshInstance

func _ready():
	get_node("../../Switch").connect("activated", self, "on_Switch_activated")

func on_Switch_activated():
	transform.origin.y = 55.528
