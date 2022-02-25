extends Camera2D

export(float) var speed = 5000

export var keyboard_zoom_multiplier = 1.01
export var scroll_wheel_zoom_multiplier = 1.08
export var drag_multiplier = 0.1

var attached = true
var drags = PoolVector2Array()
onready var current_scene = get_tree().get_current_scene()

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("cam_right") - Input.get_action_strength("cam_left")
	input_vector.y = Input.get_action_strength("cam_down") - Input.get_action_strength("cam_up")
	input_vector = input_vector.normalized()

	if input_vector:
		global_position += input_vector * speed * delta
		attached = false

	if drags.size() > 0:
		for input in drags:
			global_position += input * speed * delta
		drags = PoolVector2Array()
		attached = false

	# if InputEventScreenDrag.Fri Feb 25 13:47:16 2022

	if Input.is_action_pressed("cam_reset_pos"):
		attached = true

	if Input.is_action_pressed("cam_reset_zoom"):
		zoom = Vector2.ONE

	if Input.is_action_pressed("cam_in"):
		zoom /= keyboard_zoom_multiplier

	if Input.is_action_pressed("cam_out"):
		zoom *= keyboard_zoom_multiplier

	if attached:
		var player = current_scene.get_node("Player")
		global_position = player.global_position

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				# global_position = get_global_mouse_position()
				zoom /= scroll_wheel_zoom_multiplier
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				# global_position = get_global_mouse_position()
				zoom *= scroll_wheel_zoom_multiplier

	if event is InputEventScreenDrag:
		var input_vector = Vector2(event.relative[0], event.relative[1])
		drags.append(-input_vector * drag_multiplier)
