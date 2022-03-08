extends Node2D

export(float, 1.5, 10.0) var lifetime = 3;

onready var timer = $FadeTimer
onready var player = $FadePlayer

func _ready():
	timer.wait_time = lifetime - 1
	timer.start()

func _on_FadeTimer_timeout():
	player.play("fade")

func _on_FadePlayer_animation_finished(_anim_name):
	queue_free()
