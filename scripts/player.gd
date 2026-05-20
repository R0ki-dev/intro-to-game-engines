extends CharacterBody2D

var input_axis
const move_speed = 130.0
const JUMP_VELOCITY = -300.0
var can_dash : bool = false
const Max_jumps : int = 2
var Cur_jumps : int = 0
const dash_const = 500.00
var tween: Tween
var dash_vel = 0.0
var max_dashes : int = 0
var cur_dashes : int = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var double_jump_audio_stream_player_2d: AudioStreamPlayer2D = $DoubleJump_AudioStreamPlayer2D
@onready var jump_audio_stream_player_2d: AudioStreamPlayer2D = $Jump_AudioStreamPlayer2D
@onready var dash_audio_stream_player_2d: AudioStreamPlayer2D = $Dash_AudioStreamPlayer2D


func _physics_process(delta: float) -> void:
	if is_on_floor():
		Cur_jumps = 0
		can_dash = false
		cur_dashes = 0
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

	input_axis = Input.get_axis("move_left", "move_right")
	if input_axis:
		velocity.x = input_axis * (move_speed + dash_vel)
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	move_and_slide()
	dash()

func jump(_multi : float = 1):
	velocity.y = JUMP_VELOCITY
	can_dash = true
	if Cur_jumps == 1:
		jump_audio_stream_player_2d.play()
	else:
		double_jump_audio_stream_player_2d.play()

func dash():
	if Input.is_action_just_pressed("dash"):
		if can_dash == false:
			return
		elif cur_dashes >= max_dashes:
			return
		dash_vel = dash_const
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "dash_vel", 0, 0.2).set_ease(Tween.EASE_OUT)
		cur_dashes = cur_dashes + 1
		dash_audio_stream_player_2d.play()

func add_dash():
	max_dashes += 1
	
func attack():
	return
