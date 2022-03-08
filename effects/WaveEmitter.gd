extends Node2D

export(float, 0, 1000000.0) var lifetime = 60;
export(float, 0.1, 10.0) var period = 1;
export(PackedScene) var spawn = preload("res://effects/ShockWave.tscn")
export(Dictionary) var spawn_props = {"lifetime": 10.0}

onready var period_timer = $PeriodTimer
onready var life_timer = $LifeTimer
onready var player = $AnimationPlayer

var freeing = false

func _ready():
	period_timer.wait_time = period
	life_timer.wait_time = lifetime
	if lifetime > 0:
		life_timer.start()
	spawn_wave()

func spawn_wave():
	var node = spawn.instance()
	# node.global_position = global_position
	node.scale = scale
	for key in spawn_props:
		var value = spawn_props[key]
		node.set(key, value)
	add_child(node)

func _on_LifeTimer_timeout():
	freeing = true
	player.play("fade")

func _on_PeriodTimer_timeout():
	if not freeing:
		spawn_wave()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
