extends "res://objects/KBody.gd"


onready var WaveEmitter = preload("res://effects/WaveEmitter.tscn")


# TODO add an area tracking when two black whole are too close emit waves, emit waves for two orbiting black holes

func _on_CollisionDecection_body_entered(body):
	var wave = WaveEmitter.instance()
	wave.lifetime = 2
	wave.period = 1
	add_child(wave)
	._on_CollisionDecection_body_entered(body)
