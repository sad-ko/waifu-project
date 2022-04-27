#------------------------------------------------------------------------------#
extends Node
signal all_loaded
#------------------------------------------------------------------------------#
onready var start_menu = $StartScreen
onready var waifu = $Waifu
onready var warning = $Warning
onready var print_error = $Warning/Text
#------------------------------------------------------------------------------#
var abilities_file_path : String = "configs/abilities.wa"
#------------------------------------------------------------------------------#
func _ready() -> void:
	var _err = connect("all_loaded", start_menu, "enable_button")
	_err = start_menu.connect("tree_exited", waifu, "start_up")
	
	var abilities : Dictionary = load_abilities()
	
	if not abilities.empty():
		create_abilities(abilities, waifu.skills)
	else:
		_print_err(["[ERROR] - %s is empty." % abilities_file_path])
		return
	
	emit_signal("all_loaded")
#------------------------------------------------------------------------------#
func load_abilities() -> Dictionary:
	var abilities : Dictionary = {}
	var errors : PoolStringArray = []
	var file = File.new()
	
	var _err = file.open(abilities_file_path, File.READ)
	if _err:
		errors.append("[ERROR] - File %s could not be opened." % abilities_file_path)
		_print_err(errors)
		return {}

	var parsed_json : JSONParseResult = JSON.parse(file.get_as_text())
	if parsed_json.error:
		errors.append("[ERROR] - JSON file could not be parsed")
		errors.append("%s - %s in Line.%d" % [abilities_file_path, parsed_json.error_string, parsed_json.error_line])
		_print_err(errors)
		return {}

	abilities = parsed_json.result
	file.close()
	return abilities
#------------------------------------------------------------------------------#
func create_abilities(abilities:Dictionary, skills:Node) -> void:
	if abilities.empty():
		_print_err(["[ERROR] - Abilites dictionary is empty"])
		return

	for key in abilities:
		for ability in abilities[key]:
			if typeof(ability) == TYPE_STRING:
				skills.add_item(ability)
				skills.set_item_metadata(skills.get_item_count()-1, key)
#------------------------------------------------------------------------------#
func _print_err(errors:PoolStringArray) -> void:
	for error in errors:
		print_error.add_text(error + "\n")
		printerr(error)
	warning.popup()
	get_tree().set_pause(true)
#------------------------------------------------------------------------------#
