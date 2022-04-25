#------------------------------------------------------------------------------#
extends Control
#------------------------------------------------------------------------------#
onready var start_button : Node = $StartButton
onready var anim : Node = $AnimationPlayer
onready var print_error : Node = $PopupDialog/RichTextLabel
#------------------------------------------------------------------------------#
var initialization : FuncRef = null
#------------------------------------------------------------------------------#
func _ready() -> void:
	start_button.disabled = true

	yield(get_parent(), "ready")
	if initialization:
		var _errors : PoolStringArray = initialization.call_func()
		if not _errors.empty():
			printerr("[ERROR] - Initialization could not be resolved, exiting program...")
			print_error.text = "[ERROR] - Initialization could not be resolved, exiting program...\n"
			for error in _errors:
				print_error.add_text(error + "\n")
			$PopupDialog.popup()
			return FAILED

	anim.play("starting_up")
	yield(anim, "animation_finished")
	anim.play("starting_up_loop")
	var _err = start_button.connect("button_up", self, "start_waifu")
#------------------------------------------------------------------------------#
func enable_button() -> void:
	start_button.disabled = false
	if OS.is_debug_build():
		pass#start_button.emit_signal("button_up")
#------------------------------------------------------------------------------#
func start_waifu() -> void:
	queue_free()
#------------------------------------------------------------------------------#
