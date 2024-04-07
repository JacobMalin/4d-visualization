@tool
class_name Triangle3D
extends Node3D

@export var vertices = [
	Vector3(),
	Vector3(),
	Vector3(),
]

@export var colors = [
	Color(),
	Color(),
	Color(),
]

@export var do_normals = false
@export var normals = [
	Vector3(),
	Vector3(),
	Vector3(),
]

@onready var mesh_3d = MeshInstance3D.new()
@onready var _mesh_3d = ImmediateMesh.new()
@onready var _mat_3d = StandardMaterial3D.new()

@onready var mesh_2d = MeshInstance3D.new()
@onready var _mesh_2d = ImmediateMesh.new()
@onready var _mat_2d = StandardMaterial3D.new()

func _ready():
	# Remove 2d mesh from tiny's camera
	mesh_2d.layers = 2

	# Add children
	add_child(mesh_3d)
	add_child(mesh_2d)

func _process(_delta):
	# Material - 3d
	_mat_3d.vertex_color_use_as_albedo = true
	_mat_3d.cull_mode = BaseMaterial3D.CULL_DISABLED

	mesh_3d.material_override = _mat_3d

	# Material - 2d
	_mat_2d.vertex_color_use_as_albedo = true
	_mat_2d.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat_2d.cull_mode = BaseMaterial3D.CULL_DISABLED
	_mat_2d.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	mesh_2d.material_override = _mat_2d

	# Set default normals
	if not do_normals:
		var normal = Plane(vertices[0], vertices[1], vertices[2]).normal

		for i in range(3): normals[i] = normal
	
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
		_mesh_3d.surface_set_color(colors[i])
		if do_normals: _mesh_3d.surface_set_normal(normals[i])
		_mesh_3d.surface_add_vertex(vertices[i])
	_mesh_3d.surface_end()

func draw_2d():
	var global_vertices = []
	var global_normals = []

	for vertex in vertices:
		global_vertices += [global_transform * vertex]
	for normal in normals:
		global_normals += [global_transform * normal]

	var hits = [
		intersects_segment(global_vertices[0], global_vertices[1]),
		intersects_segment(global_vertices[1], global_vertices[2]),
		intersects_segment(global_vertices[2], global_vertices[0]),
	]

	var colors_2d = []
	var normals_2d = []
	var vertices_2d = []

	if hits[0] and hits[1] and not hits[2]:
		# Vertex 1
		colors_2d += [interp_alpha(colors[1], global_vertices[1])]
		normals_2d += [global_normals[1]]
		vertices_2d += [global_vertices[1]]
		# hits 1
		colors_2d += [interp_color(1, global_vertices, hits)]
		normals_2d += [interp_normal(1, global_vertices, hits)]
		vertices_2d += [hits[1]]
		# hits 0
		colors_2d += [interp_color(0, global_vertices, hits)]
		normals_2d += [interp_normal(0, global_vertices, hits)]
		vertices_2d += [hits[0]]
		# Vertex 2
		colors_2d += [interp_alpha(colors[2], global_vertices[2])]
		normals_2d += [global_normals[2]]
		vertices_2d += [global_vertices[2]]
		# Vertex 0
		colors_2d += [interp_alpha(colors[0], global_vertices[0])]
		normals_2d += [global_normals[0]]
		vertices_2d += [global_vertices[0]]
	elif hits[0] and not hits[1] and hits[2]:
		# Vertex 0
		colors_2d += [interp_alpha(colors[0], global_vertices[0])]
		normals_2d += [global_normals[0]]
		vertices_2d += [global_vertices[0]]
		# hits 0
		colors_2d += [interp_color(0, global_vertices, hits)]
		normals_2d += [interp_normal(0, global_vertices, hits)]
		vertices_2d += [hits[0]]
		# hits 2
		colors_2d += [interp_color(2, global_vertices, hits)]
		normals_2d += [interp_normal(2, global_vertices, hits)]
		vertices_2d += [hits[2]]
		# Vertex 1
		colors_2d += [interp_alpha(colors[1], global_vertices[1])]
		normals_2d += [global_normals[1]]
		vertices_2d += [global_vertices[1]]
		# Vertex 2
		colors_2d += [interp_alpha(colors[2], global_vertices[2])]
		normals_2d += [global_normals[2]]
		vertices_2d += [global_vertices[2]]
	elif not hits[0] and hits[1] and hits[2]:
		# Vertex 2
		colors_2d += [interp_alpha(colors[2], global_vertices[2])]
		normals_2d += [global_normals[2]]
		vertices_2d += [global_vertices[2]]
		# hits 2
		colors_2d += [interp_color(2, global_vertices, hits)]
		normals_2d += [interp_normal(2, global_vertices, hits)]
		vertices_2d += [hits[2]]
		# hits 1
		colors_2d += [interp_color(1, global_vertices, hits)]
		normals_2d += [interp_normal(1, global_vertices, hits)]
		vertices_2d += [hits[1]]
		# Vertex 0
		colors_2d += [interp_alpha(colors[0], global_vertices[0])]
		normals_2d += [global_normals[0]]
		vertices_2d += [global_vertices[0]]
		# Vertex 1
		colors_2d += [interp_alpha(colors[1], global_vertices[1])]
		normals_2d += [global_normals[1]]
		vertices_2d += [global_vertices[1]]
	else:
		for i in range(3):
			colors_2d += [interp_alpha(colors[i], global_vertices[i])]
		normals_2d = global_normals
		vertices_2d = global_vertices

	# Draw
	_mesh_2d.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(vertices_2d.size()):
		_mesh_2d.surface_set_color(colors_2d[i])
		if do_normals: _mesh_2d.surface_set_normal(global_transform.affine_inverse() * normals_2d[i])
		_mesh_2d.surface_add_vertex(global_transform.affine_inverse() * project(vertices_2d[i]))
	_mesh_2d.surface_end()

func intersects_segment(vec1, vec2):
	return FlatReference.plane.intersects_segment(vec1, vec2)

func project(vertex):
	return FlatReference.plane.project(vertex)

func interp_color(index, global_vertices, hits):
	var right_index = (index + 1) % 3

	var short = global_vertices[index].distance_to(hits[index])
	var total = global_vertices[index].distance_to(global_vertices[right_index])
	var weight = short / total

	return colors[index].lerp(colors[right_index], weight)

func interp_normal(index, global_vertices, hits):
	var right_index = (index + 1) % 3

	var short = global_vertices[index].distance_to(hits[index])
	var total = global_vertices[index].distance_to(global_vertices[right_index])
	var weight = short / total

	return normals[index].lerp(normals[right_index], weight)

func interp_alpha(color, global_vertex):
	var projected_vertex = project(global_vertex)

	var alpha = 0
	var short = projected_vertex.distance_to(global_vertex)
	var total = 0.1

	alpha = 1 - short / total

	color.a = alpha
	return color
