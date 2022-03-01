extends Node

var kbodies = [] setget set_kbodies
var timescale: float = 0.0 setget set_timescale
var rng = RandomNumberGenerator.new()

signal kbody_added
signal kbody_removed
signal kbodies_changed
signal timescale_changed

func _ready():
	rng.randomize()

func randfloat(start, end):
	return rng.randf_range(start, end)

func randint(start, end):
	return rng.randi_range(start, end)

func randv2():
	return Vector2(randfloat(0, 1), randfloat(0, 1)).normalized()

func set_timescale(value):
	timescale = max(0, value)
	emit_signal("timescale_changed", timescale)

func set_kbodies(value):
	kbodies = value
	emit_signal("kbodies_changed")

func add_kbody(body):
	kbodies.append(body)
	emit_signal("kbody_added", body)

func del_kbody(body):
	kbodies.erase(body)
	emit_signal("kbody_removed", body)
	body.queue_free()
