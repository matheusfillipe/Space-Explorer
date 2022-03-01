extends Area2D
export var capacity = 20

var refueling_bodies = []
var consumed = 0

onready var orig_modulate = modulate

func _process(delta):
	if consumed > capacity:
		queue_free()
		return

	var fueling = false
	for body in refueling_bodies:
		if body.state.fuel >= 100:
			continue
		body.state.fuel += body.refuel_rate * delta
		consumed += body.refuel_rate * delta
		fueling = true
	if fueling:
		modulate.b = max(max(orig_modulate.r, orig_modulate.g), orig_modulate.b)
		modulate.r = 1
		modulate.g = 1
	else:
		modulate = orig_modulate
	modulate.a = clamp((capacity - consumed) / capacity, 0, 1)

func _on_Refuel_body_entered(body):
	refueling_bodies.append(body)


func _on_Refuel_body_exited(body):
	refueling_bodies.erase(body)
