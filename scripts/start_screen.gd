#------------------------------------------------------------------------------#
extends Control
#------------------------------------------------------------------------------#
onready var start_button : Node = $StartButton
onready var anim : Node = $AnimationPlayer
#------------------------------------------------------------------------------#
func _ready() -> void:
	start_button.disabled = true
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
