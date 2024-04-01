@tool
class_name Torus3D
extends Node3D

@export var inner_radius = 0.5
@export var outer_radius = 1.0

@export var rings = 64
@export var ring_segments = 32

@export var colors: Color

var vertices = []
var indices = []

func _ready():
	# I did not want to make my own torus, so i borrowed this one from godot
	var min_radius = inner_radius
	var max_radius = outer_radius

	if min_radius > max_radius:
		min_radius = outer_radius
		max_radius = inner_radius

	var radius = (max_radius - min_radius) * 0.5;

	for i in range(rings + 1):
		var prevrow = (i - 1) * (ring_segments + 1)
		var thisrow = i * (ring_segments + 1)
		var inci = float(i) / rings
		var angi = inci * TAU

		var normali = Vector2(-sin(angi), -cos(angi))

		for j in range(ring_segments + 1):
			var incj = float(j) / ring_segments
			var angj = incj * TAU

			var normalj = Vector2(-cos(angj), sin(angj))
			var normalk = normalj * radius + Vector2(min_radius + radius, 0)

			vertices.push_back(Vector3(normali.x * normalk.x, normalk.y, normali.y * normalk.x))
			# normals.push_back(Vector3(normali.x * normalj.x, normalj.y, normali.y * normalj.x))
			
			if i > 0 and j > 0:
				indices.push_back(thisrow + j - 1);
				indices.push_back(prevrow + j);
				indices.push_back(prevrow + j - 1);

				indices.push_back(thisrow + j - 1);
				indices.push_back(thisrow + j);
				indices.push_back(prevrow + j);

	# Add new children
	for i in range(0, indices.size(), 3):
		var t = Triangle3D.new()

		for j in range(3):
			t.vertices[j] = vertices[indices[i+j]]

		add_child(t)
