extends "res://objects/Body.gd"


export var display_path = false
export var display_velocity = false
export var max_display_vector_scale = 5000
export var display_gravity = false
export var initial_velocity = Vector2.ZERO
export var initial_rotation = 0.0
export var color = Color(.5, 1, .5)
export var can_supernova = true

var tracked_path = PoolVector2Array()
var has_mouse = false
var died = false

const Explosion = preload("res://effects/ExplosionRefuel.tscn")
const Refuel = preload("res://objects/Refuel.tscn")
const velocity_arrow_divider = 100
const gravity_arrow_divider = 10

export(PackedScene) var death_effect = Explosion

onready var current_scene = get_tree().get_current_scene()
onready var refuels = current_scene.get_node("Refuels")
onready var collision_pos = global_position

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

func _on_CollisionDecection_body_entered(body):
	if body == self:
		return

	if "can_supernova" in body and "died" in body:
		visible = false
		sleeping = true
		if body.mass >= mass and not body.died:
			died = true
			GlobalState.del_kbody(self)
			queue_free()
			return

		var explosion = death_effect.instance()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
		explosion.scale = scale * 1.5
		explosion.timer.wait_time = 3
		explosion.spawn_parent = refuels
		explosion.spawn_props = {"scale": Vector2.ONE * mass / 200, "capacity": mass / 50}
		died = true
		GlobalState.del_kbody(self)
		queue_free()


# func _on_Explosion_ended():
# 	var refuel = Refuel.instance()
# 	refuel.global_position = collision_pos
# 	refuel.scale = Vector2.ONE * mass / 200
# 	refuel.capacity = mass / 50
# 	refuels.add_child(refuel)
# 	died = true
# 	GlobalState.del_kbody(self)
# 	queue_free()
