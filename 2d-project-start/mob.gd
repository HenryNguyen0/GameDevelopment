extends CharacterBody2D

var speed = randf_range(200, 300)
var health = 3


var slime_counter = 0

@onready var player = get_node("/root/Game/Player")

@onready var level_up = get_node("/root/Game/LevelUp")


const HEALTH_DROP: PackedScene = preload("res://health_drop.tscn")

func _ready():
	%Slime.play_walk()


func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * (speed + slime_counter * 25)
	move_and_slide()



func take_damage():
	%Slime.play_hurt()
	health -= 1

	if health == 0:
		var smoke_scene = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = smoke_scene.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		slime_counter += 1
		drop_item()
		queue_free()
		
		level_up.enemy_killed()  # notify the manager
	# existing smoke + drops + queue_free()
			

func random():
	pass

func drop_item():
	var health_drop = HEALTH_DROP.instantiate()
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_num = rng.randi_range(0, 10)
	if rand_num == 1:
		
		get_parent().call_deferred("add_child", health_drop)
		
		# create health pack at position of slime
		health_drop.call_deferred("set", "global_position", global_position)
