#------------------------------------------------------------------------------#
extends Node
#------------------------------------------------------------------------------#
export(NodePath) onready var terminal = get_node(terminal) as LineEdit
export(NodePath) onready var speech = get_node(speech) as RichTextLabel
export(NodePath) onready var sprite = get_node(sprite) as AnimatedSprite
export(NodePath) onready var skills = get_node(skills) as OptionButton
export(NodePath) onready var clear_text = get_node(clear_text) as Button
export(int) var text_speed : int = 24
#------------------------------------------------------------------------------#
var plugins_folder : String = "plugins/"
var tween : Node
#------------------------------------------------------------------------------#
func _ready() -> void:
	clear_text.hide()
	tween = Tween.new()
	speech.add_child(tween)
	var _err = tween.connect("tween_all_completed", self, "_end_speak")
#------------------------------------------------------------------------------#	
func start_up() -> void:
	speak(["hi~", "hewwo, even..."])
	terminal.grab_focus()
#------------------------------------------------------------------------------#
func _on_LineEdit_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var function : String = skills.get_item_text(skills.selected)
		var commands : PoolStringArray = terminal.text.split(" ")
		var plugin : String = skills.get_item_metadata(skills.selected)

		if plugin.empty():
			printerr("[ERROR] - Can not find plugin for function: %s" % function)

		commands.insert(0, function) # warning-ignore:return_value_discarded
		execute_skill(plugin, commands)
#------------------------------------------------------------------------------#
func execute_skill(plugin_name:String, args:PoolStringArray) -> void:
	var _args : PoolStringArray = ["-jar", plugins_folder + plugin_name + ".jar"]
	_args.append_array(args)

	var output = []
	var exit_code = OS.execute("java", _args, true, output, true)
	
	if exit_code != OK:
		printerr("[ERROR] - Program did not work as expected.")
		speak(["I'm sorry I didn't get that, would you mind saying it again?"])
	else:
		speak(output)
#------------------------------------------------------------------------------#
func speak(lines:PoolStringArray) -> void:
	var letters_amount : float = 0
	tween.remove_all()
	speech.clear()
	
	for line in lines:
		speech.add_text(line + "\n")
		letters_amount += line.length()
	
	sprite.play("default")
	
	tween.interpolate_property(speech, "percent_visible", 0.0, 1.0, letters_amount/text_speed, 0, 0)
	tween.start()
	clear_text.show()
#------------------------------------------------------------------------------#
func _end_speak() -> void:
	sprite.stop()
	sprite.frame = 0
	if speech.text.empty():
		clear_text.hide()
#------------------------------------------------------------------------------#
func _on_Clear_button_down() -> void:
	tween.remove_all()
	speech.clear()
	_end_speak()
#------------------------------------------------------------------------------#
