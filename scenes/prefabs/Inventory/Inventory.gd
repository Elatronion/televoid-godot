extends CanvasLayer

export var active_y_offset = 0
export var inactive_y_offset = 100

var desired_y_offset = active_y_offset

var show_inventory = true

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
	# Update right half
	for i in range(5, 10):
		var item_icon_node_path = "AspectRatioContainer/MarginContainer/HBoxContainer/HBoxContainerRight/ItemContainer" + str(i) + "/ItemSlot/ItemIcon"
		var item_icon_node = get_node(item_icon_node_path)
		if GameManager.items[i] != null:
			var item_icon = load("res://res/textures/sprites/inventory/items/" + GameManager.items[i] + ".png")
			item_icon_node.texture = item_icon
