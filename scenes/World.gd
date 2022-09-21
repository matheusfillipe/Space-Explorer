extends Node2D

const KBody = preload("res://objects/KBody.gd")
const Player = preload("res://objects/Player.gd")

onready var hud = $HUD
onready var canvas = $DrawCanvas

export var G = 50000
export var max_arrow_scale = 1000
export var simulation_speed: float = 0.0
export var timescale_keymap = {
	KEY_1: .1,
	KEY_2: .2,
	KEY_3: .5,
	KEY_4: .8,
	KEY_5: 1,
	KEY_6: 3,
	KEY_7: 5,
	KEY_8: 8,
	KEY_9: 10,
	KEY_0: 0,
	KEY_SPACE: 0,
}

const simulation_speed_faker = 1

var kbodies = []


func _ready():
	OS.low_processor_usage_mode = true

	Engine.time_scale = simulation_speed * simulation_speed_faker
	Utils.G = G
	for body in Utils.get_children_with_type(self, KBody):
		# warning-ignore:return_value_discarded
		body.connect("hovered", hud, "set_hover")
		body.max_display_vector_scale = min(body.max_display_vector_scale, max_arrow_scale)
		kbodies.append(body)

	GlobalState.kbodies = kbodies
	GlobalState.timescale = simulation_speed
	canvas.visible = false


func _physics_process(_delta):
	if Input.is_action_just_pressed("reset"):
		PlayerState.reset()
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

	for body1 in GlobalState.kbodies:
		body1.applied_force = Vector2.ZERO
		for body2 in GlobalState.kbodies:
			if body1 != body2:
				body1.applied_force += Utils.get_force(body1, body2)


# keyboard timescale control
func _unhandled_input(event):
	if not (event is InputEventKey and event.is_pressed()):
		return
	if event.scancode == KEY_SPACE and simulation_speed == 0:
		simulation_speed = 1
		GlobalState.timescale = simulation_speed
	elif event.scancode in timescale_keymap:
		simulation_speed = timescale_keymap[event.scancode]
		GlobalState.timescale = simulation_speed


func _on_HUD_time_scale_changed(value):
	simulation_speed = value
	Engine.time_scale = simulation_speed * simulation_speed_faker


func _on_HUD_toggle_gravity(active):
	for body in GlobalState.kbodies:
		body.display_gravity = active


func _on_HUD_toggle_speeds(active):
	for body in GlobalState.kbodies:
		body.display_velocity = active


func _on_HUD_toggle_paths(active):
	for body in GlobalState.kbodies:
		body.display_path = active
	canvas.visible = active
