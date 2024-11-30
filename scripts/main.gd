extends Node2D

@export var pipe_scene: PackedScene
@export var cloud_scene: PackedScene
@export var ground_scene: PackedScene

var score = 0

var is_game_over = false
var is_new_game = false

func increase_score():
	score += 1
	$HUD/ScoreLabel.update_score(score)
	
func game_over():
	is_game_over = true
	get_tree().call_group("pipes", "game_over")
	get_tree().call_group("clouds", "game_over")
	$PipeTimer.stop()
	$CloudTimer.stop()
	$HitSound.play()
	$HUD/GameOverLabel.show()
	$Camera2D/Background/Parallax2D.set_autoscroll(Vector2(0, 0))
	$Player.hit()
	
func restart():
	is_game_over = false
	is_new_game = false
	get_tree().call_group("pipes", "queue_free")
	get_tree().call_group("clouds", "new_game")
	$CloudTimer.start()
	$Player.restart()
	score = 0
	$HUD/ScoreLabel.update_score(score)
	$HUD/StartLabel.show()
	$HUD/GameOverLabel.hide()
	$Camera2D/Background/Parallax2D.set_autoscroll(Vector2(-100, 0))

	
func new_game():
	is_new_game = true
	$Player.new_game()
	$PipeTimer.start()
	$HUD/StartLabel.hide()
	$HUD/GameOverLabel.hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	$HUD/GameOverLabel.hide()
	#$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if is_game_over:
			restart()
		elif not is_new_game:
			new_game()
		

func _on_pipe_timer_timeout() -> void:
	# Create new isntance of the Pipe scene
	var pipe = pipe_scene.instantiate()
	
	# Select a random location along the pipe spawn path
	var pipe_spawn_location = $PipeSpawnPath/PipeSpawnLocation
	pipe_spawn_location.progress_ratio = randf()
	pipe.position = pipe_spawn_location.position
	
	# Connect the "cleared" signal from the pipe to the _on_pipe_scored function
	pipe.cleared.connect(_on_pipe_cleared)
	pipe.hit.connect(_on_pipe_hit)
	
	#Spawn the pipe by addinging it to the Main scene
	add_child(pipe)
	
func _on_pipe_cleared():
	increase_score()
	
func _on_pipe_hit():
	game_over()

func _on_cloud_timer_timeout() -> void:
	$CloudTimer.start(randi_range(3, 5))
	
	var cloud = cloud_scene.instantiate()
	
	var cloud_spawn_location = $CloudPath/CloudSpawnLocation
	cloud_spawn_location.progress_ratio = randf()
	cloud.position = cloud_spawn_location.position
	
	add_child(cloud)
	

func _on_killzone_hit() -> void:
	game_over()
