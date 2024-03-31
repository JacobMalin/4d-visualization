class_name FlatLand
extends Node3D

@export var tiny: Tiny

@onready var tiny_camera : TinyCamera = tiny.tiny_camera
@onready var bounds = $Bounds
@onready var mesh = $Mesh
@onready var _mesh = ImmediateMesh.new()

var four_corners
var normal
var d

func _ready():
	# Extract bounds
	four_corners = [
		bounds.global_position + (bounds.scale / 2) * Vector3(-1, 0, 1),
		bounds.global_position + (bounds.scale / 2) * Vector3(-1, 0, -1),
		bounds.global_position + (bounds.scale / 2) * Vector3(1, 0, 1),
		bounds.global_position + (bounds.scale / 2) * Vector3(1, 0, -1),
	]

func _process(_delta):
	# New mesh
	_mesh.clear_surfaces()

	# Draw
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for corner in four_corners:
		var vertex
		if TinyPlane.plane.is_point_over(corner):
			vertex = TinyPlane.plane.intersects_ray(corner, Vector3.DOWN)
		else:
			vertex = TinyPlane.plane.intersects_ray(corner, Vector3.UP)
		_mesh.surface_add_vertex(vertex - mesh.global_position)
	_mesh.surface_end()

	# Set mesh
	mesh.mesh = _mesh
