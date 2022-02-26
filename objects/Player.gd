extends "res://objects/KBody.gd"

export var fuel_consunption_rate = 100
export var spin_fuel_consunption_rate = 10
export var power = 100
export var break_power = 40

var has_fuel = true
var is_thrusting = false

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
		$flame.visible = false
		$flame_left.visible = false
		$flame_right.visible = false
		return

	# Spin
	if input_vector.x:
		apply_torque_impulse(power * input_vector.x)
		PlayerState.consume(delta, spin_fuel_consunption_rate)

		# Spin left
		if input_vector.x > 0:
			$flame_left.visible = true
			$flame_left.play("flame")
			$flame_right.visible = false
		# Spin Right
		else:
			$flame_right.visible = true
			$flame_right.play("flame")
			$flame_left.visible = false

	# Thrust
	if input_vector.y:
		var direction = Vector2(cos(rotation), sin(rotation))

		# Forward
		if input_vector.y  < 0:
			apply_impulse(Vector2.ZERO, direction * power)
			PlayerState.consume(delta, fuel_consunption_rate)
			is_thrusting = true
			$flame.visible = true
			$flame.play("flame")

		# Break
		else:
			apply_impulse(Vector2.ZERO, - direction * break_power)
			PlayerState.consume(delta, spin_fuel_consunption_rate * 2)
			is_thrusting = true
			$flame_left.visible = true
			$flame_left.play("flame")
			$flame_right.visible = true
			$flame_right.play("flame")

	if not input_vector:
		is_thrusting = false
		$flame.visible = false
		$flame_left.visible = false
		$flame_right.visible = false
