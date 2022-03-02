extends CanvasLayer

export var data_update_time = 0.5

signal time_scale_changed
signal toggle_
signal toggle_speeds
signal toggle_paths

var display_gravity = false
var display_velocity = false
var display_path = false
var tracking_body = null
var is_tracking = false

onready var current_scene = get_tree().get_current_scene()
onready var player = current_scene.get_node("Player")

onready var progress_bar = $HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar
onready var time_slider = $HBoxContainer/VBoxContainer/GridContainer/HSlider
onready var time_label = $HBoxContainer/VBoxContainer/GridContainer/time
onready var speeds_label = $HBoxContainer/VBoxContainer/GridContainer/velocity
onready var gravity_label = $HBoxContainer/VBoxContainer/GridContainer/gravity
onready var tracking_label = $HBoxContainer/VBoxContainer2/HBoxContainer/Tracking
onready var hover_label = $HBoxContainer/VBoxContainer2/hover
onready var data_timer = $DataTimer

func _ready():
# warning-ignore:return_value_discarded
	PlayerState.connect("fuel_changed", self, "fuel_changed")
# warning-ignore:return_value_discarded
	PlayerState.connect("no_fuel", self, "no_fuel")
# warning-ignore:return_value_discarded
	GlobalState.connect("timescale_changed", self, "set_timescale")
# warning-ignore:return_value_discarded
	PlayerState.connect("fuel_full", self, "fuel_full")
	fuel_full()

func set_timescale(value):
	time_slider.value = value

func fuel_changed(value):
	progress_bar.value = value
	progress_bar.modulate = Color(1, 1, 1, 1)

func fuel_full():
	progress_bar.modulate = Color(0, 2, 0, 1)

func no_fuel():
	progress_bar.modulate = Color(1, 0, 0, 1)

func set_tracking(body):
	tracking_label.text = body.name

func update_data(body):
	hover_label.text = body.name + " %8dau away" % Utils.body_distance(body, player)
	hover_label.text += "\nMass: " + str(body.mass)
	hover_label.add_color_override("font_color", body.color)

func set_hover(body):
	update_data(body)
	data_timer.start(data_update_time)
	tracking_body = body
	is_tracking = true
	body.connect("unhovered", self, "clear_hover")

func clear_hover(body):
	hover_label.text = ""
	is_tracking = false
	body.disconnect("unhovered", self, "clear_hover")

func _on_HSlider_value_changed(value):
	emit_signal("time_scale_changed", value)
	time_label.text = str(value)


func _on_gravity_toggled(button_pressed):
	if button_pressed and display_velocity:
		emit_signal("toggle_speeds", false)
		speeds_label.set_pressed_no_signal(false)
	emit_signal("toggle_forces", button_pressed)
	display_gravity = button_pressed
	display_velocity = false


func _on_velocity_toggled(button_pressed):
	if button_pressed and display_gravity:
		emit_signal("toggle_forces", false)
		gravity_label.set_pressed_no_signal(false)
	emit_signal("toggle_speeds", button_pressed)
	display_gravity = false
	display_velocity = button_pressed


func _on_path_toggled(button_pressed):
	emit_signal("toggle_paths", button_pressed)


func _on_DataTimer_timeout():
	if not is_tracking:
		return
	update_data(tracking_body)
	data_timer.start(data_update_time)
