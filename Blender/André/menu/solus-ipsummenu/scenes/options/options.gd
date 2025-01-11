class_name OptionsMenu

extends Control
 
@onready var exit: Button = $MarginContainer/VBoxContainer/EXIT as Button


signal exit_options_menu

func _ready():
	exit.button_down.connect(on_exit_pressed)
	set_process(false)
	
func on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)
