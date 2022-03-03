extends CanvasLayer

export var active_y_offset = 0
export var inactive_y_offset = 100

var desired_y_offset = active_y_offset

var show_inventory = true

func _ready():
	for i in range(0, 5):
		var item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerLeft/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		var item_icon_node = get_node(item_icon_node_path)
		item_icon_node.connect("mouse_entered", self, "_on_ItemIcon_mouse_entered"+str(i))
		item_icon_node.connect("mouse_exited", self, "_on_ItemIcon_mouse_exited"+str(i))
	for i in range(5, 10):
		var item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerRight/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		var item_icon_node = get_node(item_icon_node_path)
		item_icon_node.connect("mouse_entered", self, "_on_ItemIcon_mouse_entered"+str(i))
		item_icon_node.connect("mouse_exited", self, "_on_ItemIcon_mouse_exited"+str(i))

onready var label_item_name = $LabelItemName
func show_item_info(i):
	var item_name = ""
	if GameManager.items[i] != null:
		item_name = GameManager.items[i]
		var item_icon_node_path = ""
		if i < 5:
			item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerLeft/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		else:
			item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerRight/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		var item_icon_node = get_node(item_icon_node_path)
		item_icon_node.get_material().set_shader_param("enable", false)
	label_item_name.text = item_name

func hide_item_info(i):
	label_item_name.text = ""
	if GameManager.items[i] != null:
		var item_icon_node_path = ""
		if i < 5:
			item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerLeft/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		else:
			item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerRight/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		var item_icon_node = get_node(item_icon_node_path)
		item_icon_node.get_material().set_shader_param("enable", true)

func _on_ItemIcon_mouse_entered0():
	show_item_info(0)
func _on_ItemIcon_mouse_entered1():
	show_item_info(1)
func _on_ItemIcon_mouse_entered2():
	show_item_info(2)
func _on_ItemIcon_mouse_entered3():
	show_item_info(3)
func _on_ItemIcon_mouse_entered4():
	show_item_info(4)
func _on_ItemIcon_mouse_entered5():
	show_item_info(5)
func _on_ItemIcon_mouse_entered6():
	show_item_info(6)
func _on_ItemIcon_mouse_entered7():
	show_item_info(7)
func _on_ItemIcon_mouse_entered8():
	show_item_info(8)
func _on_ItemIcon_mouse_entered9():
	show_item_info(9)

func _on_ItemIcon_mouse_exited0():
	hide_item_info(0)
func _on_ItemIcon_mouse_exited1():
	hide_item_info(1)
func _on_ItemIcon_mouse_exited2():
	hide_item_info(2)
func _on_ItemIcon_mouse_exited3():
	hide_item_info(3)
func _on_ItemIcon_mouse_exited4():
	hide_item_info(4)
func _on_ItemIcon_mouse_exited5():
	hide_item_info(5)
func _on_ItemIcon_mouse_exited6():
	hide_item_info(6)
func _on_ItemIcon_mouse_exited7():
	hide_item_info(7)
func _on_ItemIcon_mouse_exited8():
	hide_item_info(8)
func _on_ItemIcon_mouse_exited9():
	hide_item_info(9)


func _process(delta):
	show_inventory = GameManager.game_state == GameManager.GameState.PLAY
	if show_inventory:
		desired_y_offset = active_y_offset
	else:
		desired_y_offset = inactive_y_offset
	offset.y += (desired_y_offset - offset.y) * 10 * delta
	
	_update_item_graphics()

func _update_item_graphics():
	# Update left half
	for i in range(0, 5):
		var item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerLeft/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		var item_icon_node = get_node(item_icon_node_path)
		if GameManager.items[i] != null:
			var item_icon = load("res://res/textures/sprites/inventory/items/" + GameManager.items[i] + ".png")
			item_icon_node.texture = item_icon
		else:
			item_icon_node.texture = null
	# Update right half
	for i in range(5, 10):
		var item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerRight/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		var item_icon_node = get_node(item_icon_node_path)
		if GameManager.items[i] != null:
			var item_icon = load("res://res/textures/sprites/inventory/items/" + GameManager.items[i] + ".png")
			item_icon_node.texture = item_icon
		else:
			item_icon_node.texture = null
