tool
extends EditorImportPlugin

const player_camera_path = "/root/SceneManager/CurrentScene/SceneTMX/Player/Camera2D"
const og_tootl_camera_z_distance = 100 * 4

func get_importer_name():
	return "elatronion.imv_importer"

func get_visible_name():
	return "IMV Animation"

func get_recognized_extensions():
	return ["imv"]

func get_save_extension():
	return "scn"

func get_priority():
	return 1

func get_import_order():
	return 100

func get_resource_type():
	return "PackedScene"

func get_preset_count():
	return 0

func get_import_options(preset):
	return [
		{
			"name": "y_is_down",
			"default_value": true
		}
	]

func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	#var animation = load_imv(source_file, options)
	var packed_scene = PackedScene.new()
	var scene = load_imv_scene(source_file, options)
	packed_scene.pack(scene)
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], packed_scene)

var televoid_sprite_names_dict = {
	"GUI Inventory Slot": "res://res/textures/sprites/inventory/item_slot.png",
	"IMV INTRO WHITE": "res://res/imv/intro_assets/white.png",
	"IMV INTRO PRINTER": "res://res/imv/intro_assets/printer.png",
	"IMV INTRO TV-TABLE": "res://res/imv/intro_assets/tv-table.png",
	"IMV INTRO CHAIR": "res://res/imv/intro_assets/chair.png",
	"IMV INTRO PLANT": "res://res/imv/intro_assets/plant.png",
	"IMV INTRO EX-BIKE": "res://res/imv/intro_assets/ex-bike.png",
	"IMV INTRO Ian Sit 1": "res://res/imv/intro_assets/ian-sit-1.png",
	"IMV INTRO Door Close": "res://res/imv/intro_assets/door-close.png",
	"IMV INTRO Door Open": "res://res/imv/intro_assets/door-open.png",
	"IMV INTRO Door Static": "res://res/imv/intro_assets/door-static.png",
	"IMV INTRO IAN-WIND-frame1": "res://res/imv/intro_assets/ian-wind-1.png",
	"IMV INTRO IAN-WIND-frame2": "res://res/imv/intro_assets/ian-wind-2.png",
	"IMV INTRO IAN-WIND-frame3": "res://res/imv/intro_assets/ian-wind-3.png",
	"IMV INTRO IAN-WIND-frame4": "res://res/imv/intro_assets/ian-wind-4.png",
	"IMV INTRO IAN-WIND-frame5": "res://res/imv/intro_assets/ian-wind-5.png",
	"IMV INTRO IAN-WIND-frame6": "res://res/imv/intro_assets/ian-wind-6.png"
}

enum ElementType { NotSet, SpriteElement, TextElement, ObjectElement}

func load_imv_scene(source_file, options):
	var root = Node2D.new()
	root.set_name(source_file.get_file().get_basename().capitalize() + source_file.get_file().get_extension().to_upper())
	root.set_script(load("res://scripts/IMV.gd"))
	
	var animation = Animation.new()
	var largest_timestamp = 0
	
	var ElementID = 0
	var position_x_track_index = null
	var position_y_track_index = null
	var position_z_track_index = null
	var scale_x_track_index = null
	var scale_y_track_index = null
	var data_track_index = null
	
	var colorR_track_index = null
	var colorG_track_index = null
	var colorB_track_index = null
	var colorA_track_index = null
	
	var last_set_image_width = 0
	var last_set_image_height = 0
	
	var last_element_type = ElementType.NotSet
	
	var f = File.new()
	f.open(source_file, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		
		if line.length() == 0:
			continue
		
		var first_char = line[0]
		
		if first_char == '#':
			continue
		elif first_char == "s":
			var strings = line.split(" ")
			var regex = RegEx.new()
			regex.compile("(?<=\").*(?=\")") # Find text between quotes exclusive
			var result = regex.search(line)
			
			var timestamp = float(strings[1])
			var wren_snippet = result.get_string()
			
			var game_manager_track_index = animation.add_track(Animation.TYPE_METHOD)
			animation.track_set_path(game_manager_track_index, "/root/GameManager")
			animation.track_insert_key(game_manager_track_index, timestamp, {"method": "ExecuteWrenSnippet", "args": [wren_snippet]})
			#print("Run snippet '" + wren_snippet + "' at timestemp " + str(timestamp))
		elif first_char == 'm':
			var regex = RegEx.new()
			regex.compile("(?<=\").*(?=\")") # Find text between quotes exclusive
			var result = regex.search(line)
			var song_by_artist = result.get_string()

			var game_manager_track_index = animation.add_track(Animation.TYPE_METHOD)
			animation.track_set_path(game_manager_track_index, "/root/GameManager")
			animation.track_insert_key(game_manager_track_index, 0, {"method": "PlayBGM", "args": [song_by_artist]})
			#print("Play song " + song_by_artist)
			
		elif first_char == 't':
			last_element_type = ElementType.TextElement
			var strings = line.split(" ")
			
			var regex = RegEx.new()
			regex.compile("(?<=\").*(?=\")") # Find text between quotes exclusive
			var text_str = regex.search(line).get_string()
			
			var x = float(strings[1])
			var y = float(strings[2])
			if options.y_is_down:
				y = -y
			var z = float(strings[3])
			var s = float(strings[4])
			
			ElementID += 1
			var element_name = "TextElement" + str(ElementID)
			
			position_x_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(position_x_track_index, element_name + ":offset:x")
			animation.track_insert_key(position_x_track_index, 0, x)
			position_y_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(position_y_track_index, element_name + ":offset:y")
			animation.track_insert_key(position_y_track_index, 0, y)
			position_z_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(position_z_track_index, element_name + ":layer")
			animation.track_insert_key(position_z_track_index, 0, z)
#			scale_x_track_index = animation.add_track(Animation.TYPE_VALUE)
#			animation.track_set_path(scale_x_track_index, element_name + ":scale:x")
			scale_y_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(scale_y_track_index, element_name + "/CenterContainer/Label:theme:default_font:size")
			animation.track_insert_key(scale_y_track_index, 0, font_float_size_to_pixel_int_size(s))
			data_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(data_track_index, element_name + "/CenterContainer/Label:text")
			animation.track_set_interpolation_type(data_track_index, Animation.INTERPOLATION_NEAREST)
			animation.track_insert_key(data_track_index, 0, text_str)
			
			colorR_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorR_track_index, element_name + "/CenterContainer/Label:modulate:r")
			animation.track_insert_key(colorR_track_index, 0, 1)
			colorG_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorG_track_index, element_name + "/CenterContainer/Label:modulate:g")
			animation.track_insert_key(colorG_track_index, 0, 1)
			colorB_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorB_track_index, element_name + "/CenterContainer/Label:modulate:b")
			animation.track_insert_key(colorB_track_index, 0, 1)
			colorA_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorA_track_index, element_name + "/CenterContainer/Label:modulate:a")
			animation.track_insert_key(colorA_track_index, 0, 1)
			
			var text_element = CanvasLayer.new()
			text_element.set_name(element_name)
			var center_container = CenterContainer.new()
			center_container.set_name("CenterContainer")
			center_container.anchor_left = 0
			center_container.anchor_top = 0
			center_container.anchor_right = 1
			center_container.anchor_bottom = 1
			center_container.margin_left = 0
			center_container.margin_top = 0
			center_container.margin_right = 0
			center_container.margin_bottom = 0
			var label = Label.new()
			label.set_name("Label")
			label.theme = Theme.new()
			label.theme.default_font = DynamicFont.new()
			label.theme.default_font.font_data = DynamicFontData.new()
			label.theme.default_font.font_data.font_path = "res://res/fonts/VCR OSD Mono.ttf"
			
			root.add_child(text_element)
			text_element.owner = root
			
			text_element.add_child(center_container)
			center_container.owner = root
			
			center_container.add_child(label)
			label.owner = root
			
		elif first_char == 'e':
			last_element_type = ElementType.SpriteElement
			var strings = line.split(" ")

			var regex = RegEx.new()
			regex.compile("(?<=\").*(?=\")") # Find text between quotes exclusive
			var sprite_name = regex.search(line).get_string()

			var x = float(strings[1])
			var y = float(strings[2])
			var z = float(strings[3])
			var sx = float(strings[4])
			var sy = float(strings[5])
			var sz = float(strings[6])
			var r = float(strings[7])
			
			if options.y_is_down:
				y = -y
			
			var image = load(televoid_sprite_names_dict[sprite_name])
			last_set_image_width = image.get_width()
			last_set_image_height = image.get_height()
			sx = sx / last_set_image_width
			sy = sy / last_set_image_height
			print(str(last_set_image_width) + "x" + str(last_set_image_height))

			ElementID += 1
			var element_name = "Element" + str(ElementID)

			position_x_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(position_x_track_index, element_name + ":position:x")
			animation.track_insert_key(position_x_track_index, 0, x)
			position_y_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(position_y_track_index, element_name + ":position:y")
			animation.track_insert_key(position_y_track_index, 0, y)
			position_z_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(position_z_track_index, element_name + ":z_index")
			animation.track_insert_key(position_z_track_index, 0, z)
			scale_x_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(scale_x_track_index, element_name + "/Sprite:scale:x")
			animation.track_insert_key(scale_x_track_index, 0, sx)
			scale_y_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(scale_y_track_index, element_name + "/Sprite:scale:y")
			animation.track_insert_key(scale_y_track_index, 0, sy)
			data_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(data_track_index, element_name + "/Sprite:texture")
			animation.track_set_interpolation_type(data_track_index, Animation.INTERPOLATION_NEAREST)
			animation.track_insert_key(data_track_index, 0, image)
			
			colorR_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorR_track_index, element_name + "/Sprite:modulate:r")
			animation.track_insert_key(colorR_track_index, 0, 1)
			colorG_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorG_track_index, element_name + "/Sprite:modulate:g")
			animation.track_insert_key(colorG_track_index, 0, 1)
			colorB_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorB_track_index, element_name + "/Sprite:modulate:b")
			animation.track_insert_key(colorB_track_index, 0, 1)
			colorA_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(colorA_track_index, element_name + "/Sprite:modulate:a")
			animation.track_insert_key(colorA_track_index, 0, 1)

			var element = Node2D.new()
			element.set_name(element_name)
			var sprite = Sprite.new()
			sprite.texture = load(televoid_sprite_names_dict[sprite_name])

			root.add_child(element)
			element.owner = root

			element.add_child(sprite)
			sprite.owner = root
		elif first_char == 'o':
			last_element_type = ElementType.ObjectElement
			var regex = RegEx.new()
			regex.compile("(?<=\").*(?=\")") # Find text between quotes exclusive
			var result = regex.search(line).get_string()
			if result == "camera":
				var camera_path = player_camera_path
				position_x_track_index = animation.add_track(Animation.TYPE_VALUE)
				animation.track_set_path(position_x_track_index, camera_path + ":global_position:x")
				#animation.track_insert_key(position_x_track_index, 0, x)
				position_y_track_index = animation.add_track(Animation.TYPE_VALUE)
				animation.track_set_path(position_y_track_index, camera_path + ":global_position:y")
				#animation.track_insert_key(position_y_track_index, 0, y)
				position_z_track_index = animation.add_track(Animation.TYPE_VALUE)
				animation.track_set_path(position_z_track_index, camera_path + ":zoom")
				var default_zoom = 0.25
				animation.track_insert_key(position_z_track_index, 0, Vector2(default_zoom, default_zoom))
			
		elif first_char == 'k':
			var strings = line.split(" ")
			
			var keyframe_type = strings[1]
			var keyframe_property = strings[2]
			var keyframe_data = float(strings[4])
			var keyframe_timestamp = float(strings[3])
			
			if keyframe_timestamp > largest_timestamp:
				largest_timestamp = keyframe_timestamp
			
			var current_track_index = null
			if keyframe_property == "x":
				current_track_index = position_x_track_index
			elif keyframe_property == "y":
				if options.y_is_down:
					keyframe_data = -keyframe_data
				current_track_index = position_y_track_index
			elif keyframe_property == "z":
				current_track_index = position_z_track_index
				if last_element_type == ElementType.ObjectElement:
					var converted_keyframe_data = keyframe_data / og_tootl_camera_z_distance
					keyframe_data = Vector2(converted_keyframe_data, converted_keyframe_data)
			elif keyframe_property == "sx":
				current_track_index = scale_x_track_index
				keyframe_data = keyframe_data / last_set_image_width
			elif keyframe_property == "sy":
				current_track_index = scale_y_track_index
				if last_element_type == ElementType.SpriteElement:
					keyframe_data = keyframe_data / last_set_image_height
				elif last_element_type == ElementType.TextElement:
					keyframe_data = font_float_size_to_pixel_int_size(keyframe_data)
			elif keyframe_property == "sz":
				pass
			elif keyframe_property == "colorR":
				current_track_index = colorR_track_index
			elif keyframe_property == "colorG":
				current_track_index = colorG_track_index
			elif keyframe_property == "colorB":
				current_track_index = colorB_track_index
			elif keyframe_property == "colorA":
				current_track_index = colorA_track_index
			
			if current_track_index == null:
				continue
			
			if keyframe_type == "linear":
				animation.track_set_interpolation_type(current_track_index, Animation.INTERPOLATION_LINEAR)
			elif keyframe_type == "easeinout":
				animation.track_set_interpolation_type(current_track_index, Animation.INTERPOLATION_CUBIC)
			elif keyframe_type == "hold":
				animation.track_set_interpolation_type(current_track_index, Animation.INTERPOLATION_NEAREST)
			
			animation.track_insert_key(current_track_index, keyframe_timestamp, keyframe_data)
			
				
		elif first_char == 'd':
			var strings = line.split(" ")
			var timestamp = float(strings[1])
			
			var regex = RegEx.new()
			regex.compile("(?<=\").*(?=\")") # Find text between quotes exclusive
			var data_str = regex.search(line).get_string()
			
			if timestamp > largest_timestamp:
				largest_timestamp = timestamp
			
			if data_track_index == null:
				continue
			
			if televoid_sprite_names_dict.has(data_str):
				var image = load(televoid_sprite_names_dict[data_str])
				last_set_image_width = image.get_width()
				last_set_image_height = image.get_height()
				
				animation.track_insert_key(data_track_index, timestamp, image)
			else:
				animation.track_insert_key(data_track_index, timestamp, data_str)
			
			#print("data '" + data_str + "' at timestamp " + str(timestamp))
	
	f.close()
	
	animation.length = largest_timestamp
	
	var animation_player = AnimationPlayer.new()
	animation_player.set_name("AnimationPlayer")
	animation_player.add_animation("IMV Animation", animation)
	animation_player.autoplay = "IMV Animation"
	
	root.add_child(animation_player)
	animation_player.owner = root
	
	return root

func font_float_size_to_pixel_int_size(float_size):
	return int(float_size*40)
