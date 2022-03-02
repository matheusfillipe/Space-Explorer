extends "res://objects/Body.gd"


export var display_path = false
export var display_velocity = false
export var max_display_vector_scale = 5000
export var display_gravity = false
export var initial_velocity = Vector2.ZERO
export var initial_rotation = 0.0
export var color = Color(.5, 1, .5)

var tracked_path = PoolVector2Array()
var has_mouse = false

const velocity_arrow_divider = 100
const gravity_arrow_divider = 10

signal hovered
signal unhovered

func _ready():
	set_linear_velocity(initial_velocity)
	$Sprite.material.set_shader_param("color", color)
	$Vector/center/arrow.material.set_shader_param("color", Color(color.r, color.g, color.b, 0.8))
	set_angular_velocity(initial_rotation)

func mark_path():
	tracked_path.append(global_position)
	return tracked_path.size() > 1

func clear_path():
	tracked_path = PoolVector2Array()

func _process(_delta):
	$Vector.visible = display_velocity or display_gravity

	if $Vector.visible:
		var vector = get_linear_velocity() if display_velocity else applied_force/mass
		var scale = vector.length() / (velocity_arrow_divider if display_velocity else gravity_arrow_divider)
		if scale > max_display_vector_scale:
			$Vector.visible = false
			return
		$Vector.global_rotation = vector.angle()
		$Vector/center.scale = Vector2.ONE * scale

func scale_click_area(value):
	$ClickArea/CollisionShape2D.scale = Vector2.ONE * value

func _on_ClickArea_mouse_entered():
	has_mouse = true
	emit_signal("hovered", self)


func _on_ClickArea_mouse_exited():
	has_mouse = false
	emit_signal("unhovered", self)
