extends Area2D
class_name AttackHitbox

var timer: Timer = Timer.new()
var child_shape: CollisionShape2D
var damage: float = 0.0
var base_knockback: float = 2.2
var knockback_growth: float = 0.1 # 0.1 per %

func _init(time: float, shape: Shape2D, attack_damage: float = 5.0, kb: float = 2.2, kb_growth: float = 0.1):
	damage = attack_damage
	base_knockback = kb
	knockback_growth = kb_growth
	child_shape = CollisionShape2D.new()
	child_shape.shape = shape
	child_shape.name = "Hitbox"
	timer.one_shot = true
	timer.connect("timeout", expire)
	timer.wait_time = time
	timer.autostart = true
	self.add_child(child_shape)
	self.add_child(timer)
	self.connect("body_entered", body_entered)

## Handles damaging fighters/actors
func body_entered(body: Node):
	if body != get_parent() and body is BaseActor:
		print("les go")

## Deletes the hitbox when the timer expires.
func expire():
	self.queue_free()
