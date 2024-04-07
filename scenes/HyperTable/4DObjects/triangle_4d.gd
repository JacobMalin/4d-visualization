@tool
class_name Triangle4D
extends Node4D

@export var vertices = [
	Vector4(),
	Vector4(),
	Vector4(),
]

@export var colors = [
	Color(),
	Color(),
	Color(),
]

# @export var do_normals = false
# @export var normals = [
# 	Vector3(),
# 	Vector3(),
# 	Vector3(),
# ]

@onready var mesh_3d = MeshInstance3D.new()
@onready var _mesh_3d = ImmediateMesh.new()
@onready var _mat_3d = StandardMaterial3D.new()

func _ready():
	# Add children
	add_child(mesh_3d)

func _process(_delta):
	# Material - 3d
	_mat_3d.vertex_color_use_as_albedo = true
	_mat_3d.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat_3d.cull_mode = BaseMaterial3D.CULL_DISABLED
	# _mat_3d.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	mesh_3d.material_override = _mat_3d

	# # Set default normals
	# if not do_normals:
	# 	var normal = Plane(vertices[0], vertices[1], vertices[2]).normal

	# 	for i in range(3): normals[i] = normal

	# Clear mesh
	_mesh_3d.clear_surfaces()

	# Draw mesh
	if HyperReference.show_3d: draw_3d()

	# Set mesh
	mesh_3d.mesh = _mesh_3d

func draw_3d():
	var global_vertices = []
	var global_normals = []

	for vertex in vertices:
		global_vertices += [_global_transform.mul(vertex)]
	# for normal in normals:
	# 	global_normals += [_global_transform.mul(normal)]

	var hits = [
		HyperReference.space.intersects_segment(global_vertices[0], global_vertices[1]),
		HyperReference.space.intersects_segment(global_vertices[1], global_vertices[2]),
		HyperReference.space.intersects_segment(global_vertices[2], global_vertices[0]),
	]

	var colors_3d = []
	var normals_3d = []
	var vertices_3d = []

	if hits[0] and hits[1] and not hits[2]:
		# Vertex 1
		colors_3d += [interp_alpha(colors[1], global_vertices[1])]
		# normals_3d += [global_normals[1]]
		vertices_3d += [global_vertices[1]]
		# hits 1
		colors_3d += [interp_color(1, global_vertices, hits)]
		# normals_3d += [interp_normal(1, global_vertices, hits)]
		vertices_3d += [hits[1]]
		# hits 0
		colors_3d += [interp_color(0, global_vertices, hits)]
		# normals_3d += [interp_normal(0, global_vertices, hits)]
		vertices_3d += [hits[0]]
		# Vertex 2
		colors_3d += [interp_alpha(colors[2], global_vertices[2])]
		# normals_3d += [global_normals[2]]
		vertices_3d += [global_vertices[2]]
		# Vertex 0
		colors_3d += [interp_alpha(colors[0], global_vertices[0])]
		# normals_3d += [global_normals[0]]
		vertices_3d += [global_vertices[0]]
	elif hits[0] and not hits[1] and hits[2]:
		# Vertex 0
		colors_3d += [interp_alpha(colors[0], global_vertices[0])]
		# normals_3d += [global_normals[0]]
		vertices_3d += [global_vertices[0]]
		# hits 0
		colors_3d += [interp_color(0, global_vertices, hits)]
		# normals_3d += [interp_normal(0, global_vertices, hits)]
		vertices_3d += [hits[0]]
		# hits 2
		colors_3d += [interp_color(2, global_vertices, hits)]
		# normals_3d += [interp_normal(2, global_vertices, hits)]
		vertices_3d += [hits[2]]
		# Vertex 1
		colors_3d += [interp_alpha(colors[1], global_vertices[1])]
		# normals_3d += [global_normals[1]]
		vertices_3d += [global_vertices[1]]
		# Vertex 2
		colors_3d += [interp_alpha(colors[2], global_vertices[2])]
		# normals_3d += [global_normals[2]]
		vertices_3d += [global_vertices[2]]
	elif not hits[0] and hits[1] and hits[2]:
		# Vertex 2
		colors_3d += [interp_alpha(colors[2], global_vertices[2])]
		# normals_3d += [global_normals[2]]
		vertices_3d += [global_vertices[2]]
		# hits 2
		colors_3d += [interp_color(2, global_vertices, hits)]
		# normals_3d += [interp_normal(2, global_vertices, hits)]
		vertices_3d += [hits[2]]
		# hits 1
		colors_3d += [interp_color(1, global_vertices, hits)]
		# normals_3d += [interp_normal(1, global_vertices, hits)]
		vertices_3d += [hits[1]]
		# Vertex 0
		colors_3d += [interp_alpha(colors[0], global_vertices[0])]
		# normals_3d += [global_normals[0]]
		vertices_3d += [global_vertices[0]]
		# Vertex 1
		colors_3d += [interp_alpha(colors[1], global_vertices[1])]
		# normals_3d += [global_normals[1]]
		vertices_3d += [global_vertices[1]]
	else:
		for i in range(3):
			colors_3d += [interp_alpha(colors[i], global_vertices[i])]
		# normals_3d = global_normals
		vertices_3d = global_vertices

	# Draw
	_mesh_3d.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(3):
		_mesh_3d.surface_set_color(colors_3d[i])
		# if do_normals: _mesh_3d.surface_set_normal(_global_transform.mul_affine_inverse(normals_3d[i]))
		var vertex = _global_transform.mul_affine_inverse(HyperReference.space.project(vertices[i]))
		_mesh_3d.surface_add_vertex(Vector3(vertex.x, vertex.y, vertex.z)) # TODO fix
	_mesh_3d.surface_end()

func interp_color(index, global_vertices, hits):
	var right_index = (index + 1) % 3

	var short = global_vertices[index].distance_to(hits[index])
	var total = global_vertices[index].distance_to(global_vertices[right_index])
	var weight = short / total

	return colors[index].lerp(colors[right_index], weight)

# func interp_normal(index, global_vertices, hits):
# 	var right_index = (index + 1) % 3

# 	var short = global_vertices[index].distance_to(hits[index])
# 	var total = global_vertices[index].distance_to(global_vertices[right_index])
# 	var weight = short / total

# 	return normals[index].lerp(normals[right_index], weight)

func interp_alpha(color, global_vertex):
	var projected_vertex = HyperReference.space.project(global_vertex)

	var alpha = 0
	var short = projected_vertex.distance_to(global_vertex)
	var total = 0.1

	alpha = 1 - short / total

	color.a = alpha
	return color