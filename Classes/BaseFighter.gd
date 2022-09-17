extends CharacterBody3D
class_name BaseFighter

var player_id = 0

var _run_speed = 5.0
var _run_speed_mult = 1.5
var _jump_velocity = 4.5

var _max_jumps = 2
var _current_jumps = 2

const DODGE_SPEED = 15

var _can_dodge = true
var _running = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# Timers
@onready var _can_move_timer = Timer.new()

func _ready():
	add_child(_can_move_timer)
	_can_move_timer.one_shot = true

func _physics_process(delta):
	if _can_move_timer.time_left > 0.0:
		if _can_move_timer.time_left > 0.06 and is_on_floor():
			_can_move_timer.stop()
			_can_move_timer.start(0.06)
		if _can_move_timer.time_left > 0.10:
			velocity.x *= 0.85
			velocity.y *= 0.85
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		_can_dodge = true
		_current_jumps = _max_jumps

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and _current_jumps > 0:
		velocity.y = _jump_velocity
		_current_jumps -= 1
	
	if Input.is_action_pressed("dodge") and _can_dodge:
		var dodge_dir = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
		if !dodge_dir.is_zero_approx():
			velocity.x = dodge_dir.x * DODGE_SPEED
			velocity.y = dodge_dir.y * DODGE_SPEED
			_can_dodge = false
			_can_move_timer.start(0.35)
	else:
		if !is_on_floor() and Input.is_action_just_released("jump") and velocity.y > 0:
			velocity.y *= 0.3
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
		var direction = (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * _run_speed * (_run_speed_mult if _running else 1.0)
		else:
			velocity.x = move_toward(velocity.x, 0, _run_speed)

	move_and_slide()
