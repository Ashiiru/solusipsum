class_name mainmenu
extends Control

@onready var start: Button = $MarginContainer/HBoxContainer/VBoxContainer/start as Button
@onready var exit: Button = $MarginContainer/HBoxContainer/VBoxContainer/exit as Button
@onready var options: Button = $MarginContainer/HBoxContainer/VBoxContainer/options as Button
@onready var start_level = preload("res://scenes/teste.tscn") as PackedScene 
#TROCAR DENTRO DE "PRELOAD" PARA PRIMEIRO NÍVEL
@onready var options_menu: OptionsMenu = $options as OptionsMenu
@onready var margin_container: MarginContainer = $MarginContainer as MarginContainer


func _ready():
	handle_connecting_signals()


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	start.button_down.connect(on_start_pressed)
	options.button_down.connect(on_options_pressed)
	exit.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
