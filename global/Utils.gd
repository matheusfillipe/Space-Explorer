extends Node

var G = 50000

func get_children_with_type(node, type):
	var matches = []
	for N in node.get_children():
		if N is type:
			matches.append(N)
		if N.get_child_count() > 0:
			matches += get_children_with_type(N, type)
	return matches

func body_distance(body1: RigidBody2D, body2: RigidBody2D) -> float:
	var p1 = body1.global_position
	var p2 = body2.global_position
	return p1.distance_to(p2)

func body_direction(body1: RigidBody2D, body2: RigidBody2D) -> Vector2:
	var p1 = body1.global_position
	var p2 = body2.global_position
	return p1.direction_to(p2).normalized()

func get_force(body1: RigidBody2D, body2: RigidBody2D) -> Vector2:
	var magnitude = body1.mass * body2.mass * G / pow(body_distance(body1, body2), 2)
	return magnitude * body_direction(body1, body2)
