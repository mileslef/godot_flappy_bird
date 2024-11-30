extends Node2D
var cloud_scale = 1
var speed = -30

func game_over():
	speed = -1

func new_game():
	speed = -30
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cloud_scale = randfn(1, 0.5)
	
	if cloud_scale < 0.25:
		cloud_scale = 0.25
	elif cloud_scale > 1.75:
		cloud_scale = 1.75
	
	scale = Vector2(cloud_scale, cloud_scale)
	z_index = round(cloud_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(speed * cloud_scale * delta)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
