extends Node

var kills: int = 0
var kills_needed: int = 5
var current_level: int = 1

@export var level_up_label: Label

@export var kill_counter_label: Label 

@export var player_start_position: Vector2 = Vector2(400, 300)

@export var enemy_spawner_timer: Timer  
@export var path_follow: PathFollow2D 


func enemy_killed():
	kills += 1
	print("Enemy killed:", kills, "/", kills_needed)
	

	if kill_counter_label:
		kill_counter_label.text = "Kills: %d/%d" % [kills, kills_needed]

	if kills >= kills_needed:
		level_complete()

func level_complete():
	if level_up_label:
		level_up_label.visible = true
	else:
		push_error("LevelUpLabel not assigned in Inspector!")

	get_tree().paused = true

	# Wait until the player presses Space
	await wait_for_space()

	# Hide the label and unpause
	if level_up_label:
		level_up_label.visible = false
	get_tree().paused = false

	# Prepare next round
	kills = 0
	kills_needed += 2
	current_level += 1
	if kill_counter_label:
		kill_counter_label.text = "Kills: %d/%d" % [kills, kills_needed]

	# Activate second gun if level >= 2
	var player = get_node("/root/Game/Player")
	var gun2 = null  # declare variable in the current scope

	if player != null and current_level >= 2:
		gun2 = player.get_node("Gun2")

	if gun2 != null:
		gun2.set_process(true)    # allow _process() to run
		gun2.visible = true       # show sprite        # show sprite
	

	reset_level()

		
func wait_for_space() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			break

	
func reset_level():
	var player = get_node("/root/Game/Player")
	player.global_position = player_start_position
	player.health = player.max_health

	# Remove existing enemies
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()

	if path_follow:
		path_follow.progress_ratio = randf()

	if enemy_spawner_timer:
		enemy_spawner_timer.start()
		
