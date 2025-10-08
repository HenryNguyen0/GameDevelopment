extends Control

@onready var more_hp_check = $VBoxContainer/MoreHealth
@onready var less_slimes_check = $VBoxContainer/LessSlimes
@onready var back_button = $VBoxContainer/Exit

func _ready():
	more_hp_check.toggled.connect(_on_more_hp_toggled)
	less_slimes_check.toggled.connect(_on_less_slimes_toggled)
	back_button.pressed.connect(_on_back_button_pressed)
	
	# Load saved settings if available
	_load_settings()


func _on_more_hp_toggled(pressed: bool):
	ProjectSettings.set_setting("game/more_hp", pressed)


func _on_less_slimes_toggled(pressed: bool):
	ProjectSettings.set_setting("game/less_slimes", pressed)


func _on_back_button_pressed():
	# Save settings before leaving
	ProjectSettings.save()
	get_tree().change_scene_to_file("res://start_menu.tscn")


func _load_settings():
	# Load and apply previous values
	if ProjectSettings.has_setting("game/more_hp"):
		more_hp_check.button_pressed = ProjectSettings.get_setting("game/more_hp")
	if ProjectSettings.has_setting("game/less_slimes"):
		less_slimes_check.button_pressed = ProjectSettings.get_setting("game/less_slimes")
