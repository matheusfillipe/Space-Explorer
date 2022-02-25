extends Camera2D

export(float) var speed = 5000

export var zoom_multiplier = 1.01

var attached = true
onready var current_scene = get_tree().get_current_scene()

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("cam_right") - Input.get_action_strength("cam_left")
	input_vector.y = Input.get_action_strength("cam_down") - Input.get_action_strength("cam_up")
	input_vector = input_vector.normalized()

	if input_vector:
		global_position += input_vector * speed * delta
		attached = false

	if Input.is_action_pressed("cam_reset_pos"):
		attached = true

	if Input.is_action_pressed("cam_reset_zoom"):
		zoom = Vector2.ONE

	if Input.is_action_pressed("cam_in"):
		zoom /= zoom_multiplier

	if Input.is_action_pressed("cam_out"):
		zoom *= zoom_multiplier

	if attached:
		var player = current_scene.get_node("Player")
		global_position = player.global_position
