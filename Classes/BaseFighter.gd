extends CharacterBody2D
class_name BaseFighter

const SPEED = 150.0
const RUN_SPEED = 230.0
const DODGE_SPEED = 300.0
const JUMP_VELOCITY = -234.0
const GRAVITY = 950
const MAX_Y_VELOCITY = 400
const MAX_JUMPS = 2
const SECONDARY_JUMP_MOD = 0.9
const WIDTH = 16
const HEIGHT = 30

var jumps: int = MAX_JUMPS
var running: bool = true
var dodging: bool = true
var dodge_started_on_ground: bool = false
var can_dodge: bool = true
var passthrough_platforms: bool = true
var old_velocity: Vector2 = Vector2.ZERO

var dodge_timer = Timer.new()

# Will probably go up to 3 (for player 4)
var playerid = 0
var is_cpu: bool = false

var collision_shape = CollisionShape2D.new()
var hitbox = Area2D.new()
var hitbox_shape = CollisionShape2D.new()
var shared_rectangle_shape = RectangleShape2D.new()

func _ready():
	shared_rectangle_shape.size = Vector2(WIDTH, HEIGHT)
	collision_shape.shape = shared_rectangle_shape
	hitbox_shape.shape = shared_rectangle_shape
	add_child(hitbox)
	hitbox.add_child(hitbox_shape)
	add_child(collision_shape)
	dodge_timer.one_shot = true
	add_child(dodge_timer)

func _physics_process(delta):
	if dodge_timer.time_left == 0.0:
		movement(delta)
	else:
		if is_on_floor() and !dodge_started_on_ground:
			dodge_timer.stop()
		else:
			velocity.x *= 0.9
			velocity.y *= 0.9
	move_and_slide()

func movement(delta: float):
	if dodging:
		dodging = false
	passthrough_platforms = Input.is_action_pressed("ui_down")
	# Add the gravity.
	if not is_on_floor():
		velocity.y = min(velocity.y + (GRAVITY * delta), MAX_Y_VELOCITY * (1.5 if passthrough_platforms else 1.0))
	elif jumps != MAX_JUMPS:
		jumps = MAX_JUMPS
	
	if is_on_floor():
		can_dodge = true
	
	if passthrough_platforms:
		self.set_collision_mask_value(2, false)
	else:
		self.set_collision_mask_value(2, true)
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = JUMP_VELOCITY * (1.0 if jumps == MAX_JUMPS else SECONDARY_JUMP_MOD)
		jumps -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var move_direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("dodge") and can_dodge:
		dodge_started_on_ground = is_on_floor()
		if !dodge_started_on_ground:
			velocity.x = direction.x * DODGE_SPEED
			velocity.y = direction.y * DODGE_SPEED
		else:
			velocity.x = move_direction * DODGE_SPEED
			if direction.y < 0:
				velocity.y = direction.y * DODGE_SPEED
				velocity.x *= 0.75
		dodge_timer.start(0.5)
		dodging = true
		can_dodge = false
		passthrough_platforms = false
		self.set_collision_mask_value(2, true)
	if move_direction:
		velocity.x = move_direction * (RUN_SPEED if running else SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	old_velocity = velocity
