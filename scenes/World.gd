extends Node2D

const KBody = preload("res://objects/KBody.gd")

export var simulation_speed: float = 0.0

const simulation_speed_faker = 0.1

var kbodies = []

func _ready():
	Engine.time_scale = simulation_speed * simulation_speed_faker
	for child in get_children():
		if child is KBody:
			kbodies.append(child)
			print(child)
	set_process(true)

func _draw():
	for body in kbodies:
		if body.display_path: # and body.tracked_path.size() > 1:
			if body.mark_path():
				draw_polyline(body.tracked_path, body.color, 1)
		else:
			body.clear_path()


func _physics_process(_delta):
	if Input.is_action_just_pressed("reset"):
		PlayerState.reset()
		get_tree().reload_current_scene()

	for body1 in kbodies:
		for body2 in kbodies:
			if body1 != body2:
				body1.applied_force = Utils.get_force(body1, body2)

	update()


func _on_HUD_time_scale_changed(value):
	simulation_speed = value
	Engine.time_scale = simulation_speed * simulation_speed_faker


func _on_HUD_toggle_forces(active):
	for body in kbodies:
		body.display_force = active


func _on_HUD_toggle_speeds(active):
	for body in kbodies:
		body.display_velocity = active


func _on_HUD_toggle_paths(active):
	for body in kbodies:
		body.display_path = active
