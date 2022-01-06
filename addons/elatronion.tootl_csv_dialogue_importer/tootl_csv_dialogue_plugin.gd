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
	var resource = Resource.new()
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], resource)
