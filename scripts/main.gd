#------------------------------------------------------------------------------#
extends Node
#------------------------------------------------------------------------------#
onready var start_menu = $StartScreen
onready var waifu = $Waifu
#------------------------------------------------------------------------------#
var abilities_file_path : String
var abilities : Dictionary
#------------------------------------------------------------------------------#
func _init() -> void:
	if OS.is_debug_build():
		abilities_file_path = "res://bin/abilities.wa"
	else:
		abilities_file_path = "./abilities.wa"
#------------------------------------------------------------------------------#
func _ready() -> void:
	start_menu.initialization = funcref(self, "load_abilities")
	waifu.initialization = funcref(self, "create_abilities")
#------------------------------------------------------------------------------#
func load_abilities() -> PoolStringArray:
	var errors : PoolStringArray = []
	var file = File.new()
	var _err = file.open(abilities_file_path, File.READ)
	if _err:
		printerr("[ERROR] - File %s could not be opened." % abilities_file_path)
		errors.append("[ERROR] - File %s could not be opened." % abilities_file_path)
		return errors

	var parsed_json : JSONParseResult = JSON.parse(file.get_as_text())
	if parsed_json.error:
		printerr("[ERROR] - JSON file could not be parsed")
		errors.append("[ERROR] - JSON file could not be parsed")
		printerr("%s - %s in Line.%d" % [abilities_file_path, parsed_json.error_string, parsed_json.error_line])
		errors.append("%s - %s in Line.%d" % [abilities_file_path, parsed_json.error_string, parsed_json.error_line])
		return errors

	abilities = parsed_json.result
	file.close()
	create_abilities(waifu.skills)
	return errors
#------------------------------------------------------------------------------#
func create_abilities(skills:Node) -> void:
	if abilities.empty():
		printerr("[ERROR] - Abilites dictionary is empty")
		return

	for key in abilities:
		for ability in abilities[key]:
			if typeof(ability) == TYPE_STRING:
				skills.add_item(ability)
				skills.set_item_metadata(skills.get_item_count()-1, key)
	start_menu.enable_button()
#------------------------------------------------------------------------------#
