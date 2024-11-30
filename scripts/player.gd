extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var rot = 0
var is_game_over = true
var game_started = false

var sprite_1 = load("res://sprites/bird_1.png")
var sprite_2 = load("res://sprites/bird_2.png")

func flap():
	velocity.y = JUMP_VELOCITY
	set_rotation(-0.5)
	$Flap.play()
	$FlapTimer.start()
	$Sprite2D.texture = sprite_2
	
func _physics_process(delta: float) -> void:
	
	if not is_game_over and game_started:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept"):
			flap()
			
		# Start rotating while bird is falling
		rot = get_rotation()
		set_rotation(rot + (2 * delta))
	
	elif game_started:
		rot = get_rotation()
		set_rotation(rot - (2 * delta))
	
	if game_started:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * 1.5 * delta
	
	move_and_slide()

func hit():
	$CollisionShape2D.set_deferred("disabled", true)
	is_game_over = true
	velocity = Vector2(-110, -400)
	$Sprite2D.texture = sprite_2
	
func restart():
	is_game_over = false
	game_started = false
	velocity = Vector2(0, 0)
	position = Vector2(80, 80)
	rotation = 0
	$Sprite2D.texture = sprite_1

func new_game():
	is_game_over = false
	game_started = true
	flap()
	$CollisionShape2D.set_deferred("disabled", false)


func _on_flap_timer_timeout() -> void:
	$Sprite2D.texture = sprite_1
