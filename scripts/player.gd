extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_MULTI = 5
var can_dash : bool = false
const Max_jumps : int = 2
var Cur_jumps : int = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var double_jump_audio_stream_player_2d: AudioStreamPlayer2D = $DoubleJump_AudioStreamPlayer2D
@onready var jump_audio_stream_player_2d: AudioStreamPlayer2D = $Jump_AudioStreamPlayer2D


func _physics_process(delta: float) -> void:
	if is_on_floor():
		Cur_jumps = 0
		can_dash = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		Cur_jumps = Cur_jumps + 1 
		if Cur_jumps > Max_jumps:
			return
		jump()
		print(Cur_jumps)
			
	if Input.is_action_just_pressed("dash"):
		if can_dash and is_on_floor() == false:
			dash()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Run")
	else:
		animated_sprite_2d.play("Jump")

	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func jump(_multi : float = 1):
	velocity.y = JUMP_VELOCITY
	can_dash = true
	if Cur_jumps == 1:
		jump_audio_stream_player_2d.play()
	else:
		double_jump_audio_stream_player_2d.play()

func dash():
	velocity.y = 0
	velocity.x = 1
	velocity.x *= DASH_MULTI
	can_dash = false
