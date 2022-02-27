extends Node2D

var kbodies = []

func _ready():
	set_process(true)

func _draw():
	for body in kbodies:
		if body.display_path: # and body.tracked_path.size() > 1:
			if body.mark_path():
				draw_polyline(body.tracked_path, body.color, 1)
		else:
			body.clear_path()


func _process(_delta):
	update()
