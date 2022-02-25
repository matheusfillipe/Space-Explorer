extends "res://objects/Body.gd"


export var display_path = false
export var display_velocity = false
export var display_force = false
export var initial_velocity = Vector2.ZERO
export var initial_rotation = 0.0
export var color = Color(.5, 1, .5)

var tracked_path = PoolVector2Array()

const vel_arrow_divider = 100
const force_arrow_divider = 1000

func _ready():
	set_linear_velocity(initial_velocity)
	$Sprite.material.set_shader_param("color", color)
	$Vector/arrow.material.set_shader_param("color", Color(color.r, color.g, color.b, 0.8))
	set_angular_velocity(initial_rotation)

func mark_path():
	tracked_path.append(global_position)
	return tracked_path.size() > 1

func clear_path():
	tracked_path = PoolVector2Array()

func _process(_delta):
	$Vector.visible = display_velocity or display_force

	if $Vector.visible:
		var vector = get_linear_velocity() if display_velocity else applied_force
		$Vector.global_rotation = vector.angle()
		var scale = vector.length() / (vel_arrow_divider if display_velocity else force_arrow_divider)
		$Vector.scale = Vector2.ONE * scale
