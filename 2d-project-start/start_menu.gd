extends Control

func _ready():
	$VBoxContainer/StartGame.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/Options.pressed.connect(_on_options_button_pressed)
	$VBoxContainer/QuitGame.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Survivors_game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options.tscn")
