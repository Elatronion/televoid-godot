tool
extends EditorImportPlugin

func get_importer_name():
	return "elatronion.tootl_csv_dialogue_importer"

func get_visible_name():
	return "T:OoTL CSV Dialogue"

func get_recognized_extensions():
	return ["csv"]

func get_save_extension():
	return "tres"

func get_priority():
	return 1

func get_import_order():
	return 100

func get_resource_type():
	return "Resource"

func get_preset_count():
	return 0

func get_import_options(preset):
	return []

func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var resource = TootlDialogue.new()
	var dialogue_events = []
	
	resource.events = load_dialogue(source_file)
	
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], resource)

func event_type_from_string(string):
	if string == "MESSAGE":
		return TootlDialogue.EVENT_MESSAGE
	if string == "LEFT":
		return TootlDialogue.EVENT_LEFT_SPRITE
	if string == "RIGHT":
		return TootlDialogue.EVENT_RIGHT_SPRITE
	if string == "SCRIPT":
		return TootlDialogue.EVENT_SCRIPT
	if string == "SNIPPET":
		return TootlDialogue.EVENT_SNIPPET

func load_dialogue(source_file):
	var dialogue_events = []
	
	var is_eos = true # Is end of string
	var last_type = ""
	var multiline_data = ""
	
	var f = File.new()
	f.open(source_file, File.READ)
	while not f.eof_reached():
		var line = f.get_line()
		
		if not is_eos:
			multiline_data += "\n" + line
			if len(line) > 0:
				if line[len(line)-1] == '"':
					is_eos = true
					multiline_data.erase(0, 1)
					multiline_data.erase(multiline_data.length() - 1, 1)
					dialogue_events.append({ type = event_type_from_string(last_type), data = multiline_data })
			continue
		
		multiline_data = ""
		
		if line.length() == 0:
			continue
		
		is_eos = true
		var split_line = line.split(",")
		var type = split_line[0]
		if type == "NULL":
			continue
		var data = split_line[1]
		
		for i in range(2, len(split_line)):
			data += ", " + split_line[i]
		
		if data[0] == '"' and data[len(data)-1] != '"':
			is_eos = false
			multiline_data = multiline_data + data
			last_type = type
			continue
		elif data[0] == '"' and data[len(data)-1] == '"':
			data.erase(0, 1)
			data.erase(data.length() - 1, 1)
		
		dialogue_events.append({ type = event_type_from_string(type), data = data })
	
	return dialogue_events
