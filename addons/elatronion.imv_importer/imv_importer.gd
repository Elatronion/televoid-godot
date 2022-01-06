tool
extends EditorPlugin

var import_plugin = null

func get_name():
	return "IMV Animation Importer"

func _enter_tree():
	import_plugin = preload("imv_import_plugin.gd").new()
	add_import_plugin(import_plugin)

func _exit_tree():
	remove_import_plugin(import_plugin)
	import_plugin = null
