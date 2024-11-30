extends Area2D

signal new_ground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(-100 * delta)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	new_ground.emit()
	queue_free()
