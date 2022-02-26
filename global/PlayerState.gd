extends Node

var fuel = 100 setget set_fuel
var timescale: float = 0.0 setget set_timescale

signal fuel_changed
signal no_fuel
signal timescale_changed

func set_timescale(value):
	timescale = max(0, value)
	emit_signal("timescale_changed", timescale)


func set_fuel(value):
	fuel = max(0, min(100, value))
	emit_signal("fuel_changed", fuel)
	if fuel <= 0:
		emit_signal("no_fuel")


func consume(delta, rate):
	var consumed = rate * delta
	self.fuel -= consumed

func reset():
	fuel = 100
