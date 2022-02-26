extends CanvasLayer

signal time_scale_changed
signal toggle_forces
signal toggle_speeds
signal toggle_paths

var display_force = false
var display_velocity = false
var display_path = false

func _ready():
	PlayerState.connect("fuel_changed", self, "fuel_changed")
	PlayerState.connect("no_fuel", self, "no_fuel")
	PlayerState.connect("timescale_changed", self, "set_timescale")

func set_timescale(value):
	$VBoxContainer/GridContainer/HSlider.value = value

func fuel_changed(value):
	$VBoxContainer/HBoxContainer/ProgressBar.value = value

func no_fuel():
	$VBoxContainer/HBoxContainer/ProgressBar.modulate = Color(1, 0, 0, 1)

func _on_HSlider_value_changed(value):
	emit_signal("time_scale_changed", value)
	$VBoxContainer/GridContainer/time.text = str(value)


func _on_forces_toggled(button_pressed):
	if button_pressed and display_velocity:
		emit_signal("toggle_speeds", false)
		$VBoxContainer/GridContainer/velocity.set_pressed_no_signal(false)
	emit_signal("toggle_forces", button_pressed)
	display_force = button_pressed
	display_velocity = false


func _on_velocity_toggled(button_pressed):
	if button_pressed and display_force:
		emit_signal("toggle_forces", false)
		$VBoxContainer/GridContainer/forces.set_pressed_no_signal(false)
	emit_signal("toggle_speeds", button_pressed)
	display_force = false
	display_velocity = button_pressed


func _on_path_toggled(button_pressed):
	emit_signal("toggle_paths", button_pressed)
