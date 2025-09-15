extends CharacterBody2D

signal health_depleted

@onready var audio = $"../AudioStreamPlayer"

@onready var hp_bar = $ProgressBar

var health: float = 100.0
var max_health: float = 100.0

func _physics_process(delta):
	const SPEED = 600.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	# Taking damage
	const DAMAGE_RATE = 10.0
	
		
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		
		if !audio.is_playing():
			audio.play()
		
		if health <= 0.0:
			health_depleted.emit()
			
func _on_health_drop_picked_up():
	health += 10
	print("Player health:", health)
	


func _ready():
	add_to_group("player")
	hp_bar.max_value = max_health
	hp_bar.value = health

func increase_health(amount: int):
	health = clamp(health + amount, 0, max_health)
	hp_bar.value = health
