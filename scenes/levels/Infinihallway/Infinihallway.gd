extends Node2D

const SECTION_WIDTH =  54
const SECTION_HEIGHT = 58

const HOTSPOT_WIDTH =  15
const HOTSPOT_HEIGHT = 29

const RENDER_DISTANCE = 5

var hotspot = preload("res://scenes/prefabs/Hotspot/Hotspot.tscn")
var hallway = preload("res://scenes/levels/Infinihallway/HallwaySection.tscn")

func infinihallway_create_door_hotspot(index, script):
	var hallway_scale = Vector2(SECTION_WIDTH, SECTION_HEIGHT)
	var hallway_position = Vector2(hallway_scale.x / 2 + index * hallway_scale.x, -20)
	var hotspot_scale = Vector2(HOTSPOT_WIDTH, HOTSPOT_HEIGHT)
	var hotspot_position = Vector2(hallway_position.x + hotspot_scale.x / 2 - 25, hallway_position.y + hotspot_scale.y / 2 - 13)
	
	var hotspot_instance = hotspot.instance()
	hotspot_instance.position = hotspot_position
	hotspot_instance.scale = hotspot_scale
	hotspot_instance.wren_script = script
	self.add_child(hotspot_instance)
	
	var hallway_instance = hallway.instance()
	hallway_instance.position = hallway_position
	hallway_instance.z_index = -5
	self.add_child(hallway_instance)

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
