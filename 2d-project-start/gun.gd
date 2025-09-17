extends Area2D

class_name Player

@export var shooting_point: Node2D

func _process(_delta):
	
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_action_just_pressed("shoot"): 
		shoot()


func shoot():
	if shooting_point == null:
		return

	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()

	new_bullet.global_position = shooting_point.global_position
	new_bullet.rotation = rotation

	get_tree().current_scene.add_child(new_bullet)
