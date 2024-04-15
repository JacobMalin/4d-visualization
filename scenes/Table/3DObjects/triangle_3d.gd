@tool
class_name Triangle3D
extends Node3D

@export var vertices = [
	Vector3(),
	Vector3(),
	Vector3(),
]

@export var color = Color.BLACK

@export var do_normals = false
@export var normals = [
	Vector3(),
	Vector3(),
	Vector3(),
]

@onready var mesh_3d = MeshInstance3D.new()
@onready var _mesh_3d = ImmediateMesh.new()
@onready var _mat_3d = preload("res://materials/table_3d_material.tres")

@onready var mesh_2d = MeshInstance3D.new()
@onready var _mesh_2d = ImmediateMesh.new()
@onready var _mat_2d = preload("res://materials/table_2d_material.tres")

var uvs = [
	Vector2(0, 1),
	Vector2(0, 0),
	Vector2(1, 1),
]

func _ready():
	# Remove 2d mesh from tiny's camera
	mesh_2d.layers = 2

	# Materials
	mesh_3d.material_override = _mat_3d
	mesh_2d.material_override = _mat_2d

	# Add children
	add_child(mesh_3d)
	add_child(mesh_2d)

func _process(_delta):
	# Set default normals
	if not do_normals:
		var normal = Plane(vertices[0], vertices[1], vertices[2]).normal

		for i in range(3): normals[i] = normal
	
	# Draw
	draw()

func draw():
	# Clear mesh
	_mesh_3d.clear_surfaces()
	_mesh_2d.clear_surfaces()

	# Draw mesh
	draw_3d()
	if FlatReference.show_2d: draw_2d()

	# Hide mesh
	if FlatReference.show_3d: mesh_3d.layers = 1
	else: mesh_3d.layers = 4

	# Set mesh
	mesh_3d.mesh = _mesh_3d
	mesh_2d.mesh = _mesh_2d

func draw_3d():
	# Draw
	_mesh_3d.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(3):
		# _mesh_3d.surface_set_color(colors[i])
		if do_normals: _mesh_3d.surface_set_normal(normals[i])
		_mesh_3d.surface_set_color(color)
		_mesh_3d.surface_add_vertex(vertices[i])
	_mesh_3d.surface_end()

func draw_2d():
	var global_vertices = []
	var global_normals = []

	for vertex in vertices:
		global_vertices += [global_transform * vertex]
	for normal in normals:
		global_normals += [global_transform * normal]

	# Shader
	mesh_2d.set_instance_shader_parameter("vertex_0", global_vertices[0])
	mesh_2d.set_instance_shader_parameter("vertex_1", global_vertices[1])
	mesh_2d.set_instance_shader_parameter("vertex_2", global_vertices[2])
	mesh_2d.set_instance_shader_parameter("_color", Vector3(color.r, color.g, color.b))

	# Matrix
	var matrix = Transform3D()
	if FlatReference.do_rotate:
		matrix = matrix.translated(-FlatReference.tiny_camera_pos)
		matrix = matrix * FlatReference.tiny_camera_transform
		matrix = matrix.rotated_local(Vector3(1, 0, 0), FlatReference.tiny_camera_rot.x)
		matrix = matrix.rotated_local(Vector3(0, 0, 1), FlatReference.tiny_camera_rot.z)
		matrix = matrix * FlatReference.tiny_camera_transform.inverse()
		matrix = matrix.translated(FlatReference.tiny_camera_pos)

	# Draw
	_mesh_2d.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(3):
		# _mesh_2d.surface_set_color(colors_2d[i])
		
		if do_normals: _mesh_2d.surface_set_normal(global_transform.affine_inverse() * global_normals[i])
		
		_mesh_2d.surface_set_uv(uvs[i])

		var vertex = project(global_vertices[i])

		vertex = matrix.inverse() * vertex

		var inversed = global_transform.affine_inverse() * vertex
		
		_mesh_2d.surface_add_vertex(inversed)
	_mesh_2d.surface_end()

func project(vertex):
	return FlatReference.plane.project(vertex)
