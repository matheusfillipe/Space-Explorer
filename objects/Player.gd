extends "res://objects/KBody.gd"

export var fuel_consunption_rate = 200
export var spin_fuel_consunption_rate = 10
export var power = 100

var has_fuel = true

func _ready():
	PlayerState.connect("no_fuel", self, "no_fuel")

func no_fuel():
	has_fuel = false

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if not has_fuel:
		return

	# Spin
	if input_vector.x:
		apply_torque_impulse(power * input_vector.x)
		PlayerState.consume(delta, spin_fuel_consunption_rate)

	# Thrust
	if input_vector.y:
		var direction = Vector2(cos(rotation), sin(rotation))
		apply_impulse(Vector2.ZERO, - direction * input_vector.y * power)
		PlayerState.consume(delta, fuel_consunption_rate)
