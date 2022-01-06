tool
extends EditorPlugin

var import_plugin = null
#var tileset_import_plugin = null

func get_name():
	return "T:OoTL CSV Dialogue Importer"

func _enter_tree():
	#if not ProjectSettings.has_setting("tiled_importer/enable_json_format"):
	#	ProjectSettings.set_setting("tiled_importer/enable_json_format", true)

	import_plugin = preload("tootl_csv_dialogue_plugin.gd").new()
	#tileset_import_plugin = preload("tiled_tileset_import_plugin.gd").new()
	add_import_plugin(import_plugin)
	#add_import_plugin(tileset_import_plugin)

func _exit_tree():
	remove_import_plugin(import_plugin)
	#remove_import_plugin(tileset_import_plugin)
	import_plugin = null
	#tileset_import_plugin = null
