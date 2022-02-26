extends CanvasLayer

signal time_scale_changed
signal toggle_forces
signal toggle_speeds
signal toggle_paths

var display_force = false
var display_velocity = false
var display_path = false

onready var current_scene = get_tree().get_current_scene()
onready var player = current_scene.get_node("Player")

onready var progress_bar = $HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar
onready var time_slider = $HBoxContainer/VBoxContainer/GridContainer/HSlider
onready var time_label = $HBoxContainer/VBoxContainer/GridContainer/time
onready var speeds_label = $HBoxContainer/VBoxContainer/GridContainer/velocity
onready var forces_label = $HBoxContainer/VBoxContainer/GridContainer/forces
onready var tracking_label = $HBoxContainer/VBoxContainer2/HBoxContainer/Tracking
onready var hover_label = $HBoxContainer/VBoxContainer2/hover

func _ready():
# warning-ignore:return_value_discarded
	PlayerState.connect("fuel_changed", self, "fuel_changed")
# warning-ignore:return_value_discarded
	PlayerState.connect("no_fuel", self, "no_fuel")
# warning-ignore:return_value_discarded
	PlayerState.connect("timescale_changed", self, "set_timescale")

func set_timescale(value):
	time_slider.value = value

func fuel_changed(value):
	progress_bar.value = value

func no_fuel():
	progress_bar.modulate = Color(1, 0, 0, 1)

func set_tracking(body):
	tracking_label.text = body.name

func set_hover(body):
	print("hud hover: ", body)
	hover_label.add_color_override("font_color", body.color)
	hover_label.text = body.name + " %5.2fau away" % Utils.body_distance(body, player)
	body.connect("unhovered", self, "clear_hover")

func clear_hover(body):
	hover_label.text = ""
	body.disconnect("unhovered", self, "clear_hover")

func _on_HSlider_value_changed(value):
	emit_signal("time_scale_changed", value)
	time_label.text = str(value)


func _on_forces_toggled(button_pressed):
	if button_pressed and display_velocity:
		emit_signal("toggle_speeds", false)
		speeds_label.set_pressed_no_signal(false)
	emit_signal("toggle_forces", button_pressed)
	display_force = button_pressed
	display_velocity = false


func _on_velocity_toggled(button_pressed):
	if button_pressed and display_force:
		emit_signal("toggle_forces", false)
		forces_label.set_pressed_no_signal(false)
	emit_signal("toggle_speeds", button_pressed)
	display_force = false
	display_velocity = button_pressed


func _on_path_toggled(button_pressed):
	emit_signal("toggle_paths", button_pressed)
