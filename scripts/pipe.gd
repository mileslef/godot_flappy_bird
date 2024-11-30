extends RigidBody2D

signal cleared
signal hit

var pipe_velocity = -100

func game_over():
	pipe_velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(pipe_velocity * delta)
	#linear_velocity = pipe_velocity


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_score_area_body_entered(body: Node2D) -> void:
	cleared.emit()
	$ScoreSound.play()


func _on_hit_area_body_entered(body: Node2D) -> void:
	hit.emit()
