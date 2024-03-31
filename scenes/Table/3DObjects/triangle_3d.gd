@tool
class_name Triangle3D
extends MeshInstance3D

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

@onready var _mesh = ImmediateMesh.new()
@onready var _mat = StandardMaterial3D.new()

const vfov = 75

func _ready():
	# Move off of tiny's camera
	layers -= 1
	layers += 2

func _process(_double):
	# Material
	_mat.vertex_color_use_as_albedo = true
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material_override = _mat
	
	# Clear mesh
	_mesh.clear_surfaces()

	if Reference3D.show_3d: draw_3d()

	if Reference3D.show_2d: draw_2d()

	# Set mesh
	self.mesh = _mesh

func draw_3d():
	# Draw
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(3):
		_mesh.surface_set_color(colors[i])
		_mesh.surface_add_vertex(vertices[i])
	_mesh.surface_end()

func draw_2d():
	var global_vertices = []

	for vertex in vertices:
		global_vertices += [vertex + global_position]

	var hits = [
		intersects_segment(global_vertices[0], global_vertices[1]),
		intersects_segment(global_vertices[1], global_vertices[2]),
		intersects_segment(global_vertices[2], global_vertices[0]),
	]

	var colors_2d = []
	var vertices_2d = []

	if hits[0] and hits[1] and not hits[2]:
		# Vertex 1
		colors_2d += [interp_alpha(colors[1], global_vertices[1])]
		vertices_2d += [global_vertices[1]]
		# hits 1
		colors_2d += [interp_color(1, global_vertices, hits)]
		vertices_2d += [hits[1]]
		# hits 0
		colors_2d += [interp_color(0, global_vertices, hits)]
		vertices_2d += [hits[0]]
		# Vertex 2
		colors_2d += [interp_alpha(colors[2], global_vertices[2])]
		vertices_2d += [global_vertices[2]]
		# Vertex 0
		colors_2d += [interp_alpha(colors[0], global_vertices[0])]
		vertices_2d += [global_vertices[0]]
	elif hits[0] and not hits[1] and hits[2]:
		# Vertex 0
		colors_2d += [interp_alpha(colors[0], global_vertices[0])]
		vertices_2d += [global_vertices[0]]
		# hits 0
		colors_2d += [interp_color(0, global_vertices, hits)]
		vertices_2d += [hits[0]]
		# hits 2
		colors_2d += [interp_color(2, global_vertices, hits)]
		vertices_2d += [hits[2]]
		# Vertex 1
		colors_2d += [interp_alpha(colors[1], global_vertices[1])]
		vertices_2d += [global_vertices[1]]
		# Vertex 2
		colors_2d += [interp_alpha(colors[2], global_vertices[2])]
		vertices_2d += [global_vertices[2]]
	elif not hits[0] and hits[1] and hits[2]:
		# Vertex 2
		colors_2d += [interp_alpha(colors[2], global_vertices[2])]
		vertices_2d += [global_vertices[2]]
		# hits 2
		colors_2d += [interp_color(2, global_vertices, hits)]
		vertices_2d += [hits[2]]
		# hits 1
		colors_2d += [interp_color(1, global_vertices, hits)]
		vertices_2d += [hits[1]]
		# Vertex 0
		colors_2d += [interp_alpha(colors[0], global_vertices[0])]
		vertices_2d += [global_vertices[0]]
		# Vertex 1
		colors_2d += [interp_alpha(colors[1], global_vertices[1])]
		vertices_2d += [global_vertices[1]]
	else:
		for i in range(3):
			colors_2d += [interp_alpha(colors[i], global_vertices[i])]
		vertices_2d = global_vertices
	
	# Draw
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(vertices_2d.size()):
		_mesh.surface_set_color(colors_2d[i])
		_mesh.surface_add_vertex(project(vertices_2d[i]) - global_position)
	_mesh.surface_end()

func intersects_segment(vec1, vec2):
	return TinyPlane.plane.intersects_segment(vec1, vec2)

func project(vertex):
	return TinyPlane.plane.project(vertex)

func interp_color(index, global_vertices, hits):
	var right_index = (index + 1) % 3

	var short = global_vertices[index].distance_to(hits[index])
	var total = global_vertices[index].distance_to(global_vertices[right_index])
	var weight = short / total

	return colors[index].lerp(colors[right_index], weight)

func interp_alpha(color, global_vertex):
	var projected_vertex = project(global_vertex)
	var frustrum_vertex = TinyPlane.frustrum_plane.intersects_ray(projected_vertex, TinyPlane.plane.normal)

	var alpha = 0
	if frustrum_vertex:
		var short = projected_vertex.distance_to(global_vertex)
		var total = projected_vertex.distance_to(frustrum_vertex)

		alpha = 1 - short / total

	color.a = alpha
	return color