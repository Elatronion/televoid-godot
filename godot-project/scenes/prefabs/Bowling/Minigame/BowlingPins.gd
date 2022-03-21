extends Spatial

onready var pin_scene = preload("res://scenes/prefabs/Bowling/Pins/BowlingPin.tscn")

onready var pins = $Pins
onready var positions = $Positions

func _process(delta):
	if Input.is_action_just_pressed("imv_skip"):
		reset_pins()

func clear_pins():
	for pin in pins.get_children():
		pin.queue_free()

func reset_pins():
	clear_pins()
	for position in positions.get_children():
		var pin_instance = pin_scene.instance()
		pins.add_child(pin_instance)
		pin_instance.global_transform.origin = position.global_transform.origin
