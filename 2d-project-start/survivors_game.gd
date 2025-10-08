extends Node2D

@onready var audio = $BGM
@onready var path_follow = $Player/Path2D/PathFollow2D
@onready var timer = $Timer

# Base spawn interval
@export var spawn_interval = .5
# Multiplier for slower spawning when Less Slimes is enabled
@export var less_slimes_multiplier = 1.0
# Max number of slimes allowed on screen normally
@export var max_slimes = 10
# Max number of slimes when Less Slimes is enabled
@export var max_slimes_less = 5

# Read setting from Options Menu
var less_slimes_enabled = ProjectSettings.get_setting("game/less_slimes", false)

func _ready():
	# Adjust spawn interval based on Less Slimes option
	if less_slimes_enabled:
		timer.wait_time = spawn_interval * less_slimes_multiplier
	else:
		timer.wait_time = spawn_interval

	timer.start()


func spawn_mob():
	# Check max mobs allowed
	var current_enemies = get_tree().get_nodes_in_group("Enemies").size()
	if less_slimes_enabled:
		if current_enemies >= max_slimes_less:
			return
	else:
		if current_enemies >= max_slimes:
			return

	# Instantiate and position new mob
	var new_mob = preload("res://mob.tscn").instantiate()
	path_follow.progress_ratio = randf()
	new_mob.global_position = path_follow.global_position
	add_child(new_mob)

	new_mob.add_to_group("Enemies")

	# Play BGM 
	if !audio.is_playing():
		audio.play()


func _on_timer_timeout():
	spawn_mob()
