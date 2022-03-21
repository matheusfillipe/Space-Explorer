extends "res://objects/KBody.gd"


onready var WaveEmitter = preload("res://effects/WaveEmitter.tscn")


func _on_CollisionDecection_body_entered(body):
	var wave = WaveEmitter.instance()
	wave.lifetime = 2
	wave.period = 1
	add_child(wave)
	._on_CollisionDecection_body_entered(body)
