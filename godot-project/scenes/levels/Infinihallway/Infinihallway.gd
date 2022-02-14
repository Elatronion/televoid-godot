extends Node2D

const SECTION_WIDTH =  54
const SECTION_HEIGHT = 58
const RENDER_DISTANCE = 15

var hallway_scene = preload("res://scenes/levels/Infinihallway/HallwaySection.tscn")

var hallway_section = preload("res://res/textures/sprites/Outervoid/Hallway Section.png")
var hallway_destroyed = preload("res://res/textures/sprites/Outervoid/Hallway - Destroyed.png")

var current_last = -2

var doors_with_hotspot = {}

func infinihallway_create_door_hotspot(index, script):
	doors_with_hotspot[index] = script

func script_at_index(index):
	var script_for_door = "res/scripts/Infinihallway/Door Else.wren"
	if index in doors_with_hotspot.keys():
		script_for_door = doors_with_hotspot[index]
	return script_for_door

func add_hallway_section(index):
	var hallway_scale = Vector2(SECTION_WIDTH, SECTION_HEIGHT)
	var hallway_position = Vector2(hallway_scale.x / 2 + index * hallway_scale.x, -20)
	
	var sprite_instance = hallway_scene.instance()
	sprite_instance.name = str(index)
	sprite_instance.position = hallway_position
	sprite_instance.z_index = -5
	sprite_instance.texture = hallway_section
	sprite_instance.get_node("Label").text = str(index)
	sprite_instance.get_node("Hotspot").wren_script = script_at_index(index)
	self.add_child(sprite_instance)
	current_last = index

func remove_hallway_section(index):
	if index >= -1:
		get_node(str(index)).queue_free()
		var last_hallway_section = get_node(str(index+1))
		last_hallway_section.texture = hallway_destroyed
		for child in last_hallway_section.get_children():
			child.queue_free()

func step():
	remove_hallway_section(current_last-RENDER_DISTANCE)
	add_hallway_section(current_last+1)

func _ready():
	infinihallway_create_door_hotspot(1, "res/scripts/Infinihallway/Door 1-5.wren");
	infinihallway_create_door_hotspot(2, "res/scripts/Infinihallway/Door 1-5.wren");
	infinihallway_create_door_hotspot(3, "res/scripts/Infinihallway/Door 1-5.wren");
	infinihallway_create_door_hotspot(4, "res/scripts/Infinihallway/Door 1-5.wren");
	infinihallway_create_door_hotspot(5, "res/scripts/Infinihallway/Door 1-5.wren");
	infinihallway_create_door_hotspot(6, "res/scripts/Infinihallway/Door 6.wren");
	infinihallway_create_door_hotspot(7, "res/scripts/Infinihallway/Door 7.wren");
	infinihallway_create_door_hotspot(8, "res/scripts/Infinihallway/Door 8.wren");
	infinihallway_create_door_hotspot(9, "res/scripts/Infinihallway/Door 9.wren");
	infinihallway_create_door_hotspot(10, "res/scripts/Infinihallway/Door 10.wren");
	infinihallway_create_door_hotspot(11, "res/scripts/Infinihallway/Door 11.wren");
	infinihallway_create_door_hotspot(15, "res/scripts/Infinihallway/Door 15.wren");
	infinihallway_create_door_hotspot(16, "res/scripts/Infinihallway/Door 16.wren");
	infinihallway_create_door_hotspot(17, "res/scripts/Infinihallway/Door 17.wren");
	infinihallway_create_door_hotspot(22, "res/scripts/Infinihallway/Door 22.wren");
	infinihallway_create_door_hotspot(24, "res/scripts/Infinihallway/Door 24.wren");
	infinihallway_create_door_hotspot(25, "res/scripts/Infinihallway/Door 25.wren");
	infinihallway_create_door_hotspot(30, "res/scripts/Infinihallway/Door 30.wren");
	infinihallway_create_door_hotspot(42, "res/scripts/Infinihallway/Door 42.wren");
	infinihallway_create_door_hotspot(45, "res/scripts/Infinihallway/Door 45.wren");
	infinihallway_create_door_hotspot(50, "res/scripts/Infinihallway/Door 50.wren");
	infinihallway_create_door_hotspot(51, "res/scripts/Infinihallway/Door 51.wren");
	infinihallway_create_door_hotspot(69, "res/scripts/Infinihallway/Door 69.wren");
	infinihallway_create_door_hotspot(75, "res/scripts/Infinihallway/Door 75.wren");
	infinihallway_create_door_hotspot(80, "res/scripts/Infinihallway/Door 80.wren");
	infinihallway_create_door_hotspot(90, "res/scripts/Infinihallway/Door 90.wren");
	infinihallway_create_door_hotspot(99, "res/scripts/Infinihallway/Door 99.wren");
	infinihallway_create_door_hotspot(100, "res/scripts/Infinihallway/Door 100.wren");
	for i in range(current_last, RENDER_DISTANCE):
		step()

var _player = null
func _find_player():
	_player = get_node(GameManager.player_path)

func _process(delta):
	if _player == null:
		_find_player()
		return
	
	if _player.position.x > (current_last - RENDER_DISTANCE * 0.5) * SECTION_WIDTH:
		step()
	if _player.position.x < (current_last-RENDER_DISTANCE) * SECTION_WIDTH:
		exit_infinihallway()

var _load_left = false
func exit_infinihallway():
	if not _load_left:
		_load_left = true
		GameManager.LoadScene("res/scenes/HUB/HUB.tmx")
