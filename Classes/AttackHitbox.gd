extends Area2D
class_name AttackHitbox

var color_node: ColorRect

var timer: Timer = Timer.new()
var child_shape: CollisionShape2D
var damage: float = 0.0
var base_knockback: Vector2 = Vector2(2.2, 0.0)
var knockback_growth: Vector2 = Vector2(0.1, 0.0)
var angle: float = 25.0
var look_right: bool = false

var bodies_interacted_with = []

func _init(time: float, shape: Shape2D, looking_right, attack_damage: float = 5.0, kb: Vector2 = Vector2(120.0, -80.0), kb_growth: Vector2 = Vector2(1.2, -0.3), at_angle: float = 0.0):
	self.color_node = ColorRect.new()
	self.color_node.color = "#00FF0084"
	self.set_collision_mask_value(3, true)
	self.position.x = 20 * (1 if looking_right else -1)
	monitorable = false
	look_right = looking_right
	angle = at_angle
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
	child_shape.add_child(color_node)
	color_node.size = shape.size
	color_node.anchors_preset = 8
	self.add_child(timer)
	self.connect("body_entered", body_entered)
	Main.connect("debug_changed", change_color_shape_visibility)
	color_node.visible = Main.debug

func _exit_tree():
	Main.disconnect("debug_changed", change_color_shape_visibility)

## Handles damaging fighters/actors
func body_entered(body: Node):
	if body != get_parent() and body is BaseActor:
		if body.name not in bodies_interacted_with:
			body.damage(damage, base_knockback, knockback_growth, angle, look_right)
			bodies_interacted_with.append(body.name)

## Deletes the hitbox when the timer expires.
func expire():
	self.queue_free()

func change_color_shape_visibility(debug: bool):
	color_node.visible = debug
