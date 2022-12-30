extends CharacterBody2D
class_name BaseActor

var health: float = 0.0 # In Stamina battles, this should be health
var looking_right: bool = true

func movement(delta: float) -> void:
	move_and_slide()

func ai(delta: float) -> void:
	movement(delta)

func _physics_process(delta):
	ai(delta)

func damage(applied_damage: float, knockback: Vector2 = Vector2.ZERO, knockback_gain: Vector2 = Vector2.ZERO, degrees: float = 25.0, look_right: bool = false):
	var applied_knockback = knockback
	#print(applied_knockback)
	applied_knockback += (knockback_gain * health)
	#print(applied_knockback)
	health = clamp(health + applied_damage, 0.0, 999.99)
	applied_knockback = applied_knockback.rotated(deg_to_rad(degrees))
	if not look_right:
		applied_knockback.x = -applied_knockback.x
	#print(velocity)
	velocity += applied_knockback
	#print(health)
	#print(velocity)
