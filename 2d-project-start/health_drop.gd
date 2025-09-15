extends Area2D



func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("increase_health"):
			body.increase_health(20)  # restore 20 HP
		queue_free()
