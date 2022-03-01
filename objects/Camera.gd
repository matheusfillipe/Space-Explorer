extends Camera2D

export(float) var speed = 5000

export var keyboard_zoom_multiplier = 1.01
export var scroll_wheel_zoom_multiplier = 1.08
export var drag_multiplier = 0.05

onready var current_scene = get_tree().get_current_scene()
onready var player = current_scene.get_node("Player")
onready var hud = current_scene.get_node("HUD")
onready var track_object = player

var drags = PoolVector2Array()
var attached = true
var paralax_layers = []

func _ready():
	for layer in Utils.get_children_with_type(self, ParallaxLayer):
		paralax_layers.append([layer, layer.motion_scale])

func update_paralax():
	"""Change paralax on zooming"""
	for layer in paralax_layers:
		layer[0].motion_scale.x = layer[1].x / zoom.x
		layer[0].motion_scale.y = layer[1].y / zoom.y

	# HACK This is so the paralax doesn't disappear when detached
	global_position += Vector2(0, -10)

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("cam_right") - Input.get_action_strength("cam_left")
	input_vector.y = Input.get_action_strength("cam_down") - Input.get_action_strength("cam_up")
	input_vector = input_vector.normalized()

	if input_vector:
		global_position += input_vector * speed * max(delta, 0.00166) * zoom
		attached = false

	if drags.size() > 0:
		for input in drags:
			global_position += input * speed * max(delta, 0.00166) * zoom
		drags = PoolVector2Array()
		attached = false

	if Input.is_action_pressed("cam_reset_pos"):
		attached = true
		zoom = Vector2.ONE
		update_paralax()

	if Input.is_action_pressed("cam_reset_zoom"):
		zoom = Vector2.ONE
		update_paralax()

	if Input.is_action_pressed("cam_in"):
		zoom /= keyboard_zoom_multiplier
		update_paralax()

	if Input.is_action_pressed("cam_out"):
		zoom *= keyboard_zoom_multiplier
		update_paralax()

	if Input.is_action_just_pressed("mouse_left_click"):
		for body in GlobalSate.kbodies:
			if body.has_mouse:
				track_object = body
				attached = true
				break

	if Input.is_action_just_pressed("track_player"):
		track_object = player
		zoom = Vector2.ONE
		update_paralax()
		attached = true

	# Scale click areas
	for body in GlobalSate.kbodies:
		body.scale_click_area(zoom)


	if attached:
		global_position = track_object.global_position
		hud.set_tracking(track_object)

func _unhandled_input(event):
	if event is InputEventScreenDrag:
		var input_vector = Vector2(event.relative[0], event.relative[1])
		drags.append(-input_vector * drag_multiplier)
		return

	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				# global_position = get_global_mouse_position()
				zoom /= scroll_wheel_zoom_multiplier
				update_paralax()
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				# global_position = get_global_mouse_position()
				zoom *= scroll_wheel_zoom_multiplier
				update_paralax()
