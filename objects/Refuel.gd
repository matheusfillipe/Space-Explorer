extends Area2D

export var capacity = 20.0
export var consume_color_highlight = Color(3, 4, 6)

var refueling_bodies = []
var consumed = 0.0

onready var sprite = $Sprite
onready var orig_modulate = sprite.modulate

func _ready():
	var random_velocity = GlobalState.randv2() * 0.1
	sprite.material.set_shader_param("velocity", random_velocity)

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
		sprite.modulate = consume_color_highlight
	else:
		sprite.modulate = orig_modulate
	sprite.modulate.a = clamp((capacity - consumed) / capacity, 0, 1)

func _on_Refuel_body_entered(body):
	refueling_bodies.append(body)


func _on_Refuel_body_exited(body):
	refueling_bodies.erase(body)
