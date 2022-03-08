extends Node2D

export(float, 1.5, 10.0) var lifetime = 3;
export(float, 0.0, 1.0) var strength = 0.01;

onready var timer = $FadeTimer
onready var player = $FadePlayer
onready var sprite = $Explosion/Sprite

func _ready():
	sprite.material.set_shader_param("force", strength)
	timer.wait_time = lifetime - 1
	timer.start()

func _free():
	player.play("fade")

func _on_FadeTimer_timeout():
	player.play("fade")

func _on_FadePlayer_animation_finished(_anim_name):
	queue_free()
