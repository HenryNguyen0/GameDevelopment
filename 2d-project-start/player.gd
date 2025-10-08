extends CharacterBody2D

signal health_depleted

@onready var audio = $"../AudioStreamPlayer"
@onready var pickupSound = $HealthSound
@onready var hp_bar = $ProgressBar

# Settings loaded from ProjectSettings
var more_hp_enabled = ProjectSettings.get_setting("game/more_hp", false)
var less_slimes_enabled = ProjectSettings.get_setting("game/less_slimes", false)

var health: float = 100.0
var max_health: float = 100.0

func _ready():
	add_to_group("player")

	# Apply More HP setting at start
	if more_hp_enabled:
		max_health = 150.0
		health = 150.0
	else:
		max_health = 100.0
		health = 100.0

	hp_bar.max_value = max_health
	hp_bar.value = health


func _physics_process(delta):
	const SPEED = 600.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()

	# Movement animations
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "default"

	if velocity.x < 0:
		$AnimatedSprite2D.animation = "left"
	elif velocity.x > 0:
		$AnimatedSprite2D.animation = "right"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "up"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "down"

	# Taking damage
	const DAMAGE_RATE = 10.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		hp_bar.value = health

		if !audio.is_playing():
			audio.play()

		if health <= 0.0:
			health_depleted.emit()


func increase_health(amount: int):
	health = clamp(health + amount, 0, max_health)
	hp_bar.value = health

	if pickupSound:
		pickupSound.stop()
		pickupSound.play()
