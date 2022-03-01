extends Node

var fuel = 100 setget set_fuel

signal fuel_changed
signal no_fuel
signal fuel_full

func _ready():
	reset()

func set_fuel(value):
	fuel = max(0, min(100, value))
	emit_signal("fuel_changed", fuel)
	if fuel <= 0:
		emit_signal("no_fuel")
	if fuel == 100:
		emit_signal("fuel_full")


func consume(delta, rate):
	var consumed = rate * delta
	self.fuel -= consumed

func reset():
	fuel = 100
	emit_signal("fuel_full")
