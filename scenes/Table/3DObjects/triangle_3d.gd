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

func _process(_double):
	# Clear mesh
	_mesh.clear_surfaces()

	draw_3d()

	draw_2d()

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

	var hit0 = intersects_segment(global_vertices[0], global_vertices[1])
	var hit1 = intersects_segment(global_vertices[1], global_vertices[2])
	var hit2 = intersects_segment(global_vertices[2], global_vertices[0])

	var colors_2d = []
	var vertices_2d = []

	if hit0 and hit1 and not hit2:
		# Vertex 1
		colors_2d += [colors[1]]
		vertices_2d += [global_vertices[1]]
		# Hit 1
		colors_2d += [colors[1]]
		vertices_2d += [hit1]
		# Hit 0
		colors_2d += [colors[0]]
		vertices_2d += [hit0]
		# Vertex 2
		colors_2d += [colors[2]]
		vertices_2d += [global_vertices[2]]
		# Vertex 0
		colors_2d += [colors[0]]
		vertices_2d += [global_vertices[0]]
	elif hit0 and not hit1 and hit2:
		# Vertex 0
		colors_2d += [colors[0]]
		vertices_2d += [global_vertices[0]]
		# Hit 0
		colors_2d += [colors[0]]
		vertices_2d += [hit0]
		# Hit 2
		colors_2d += [colors[2]]
		vertices_2d += [hit2]
		# Vertex 1
		colors_2d += [colors[1]]
		vertices_2d += [global_vertices[1]]
		# Vertex 2
		colors_2d += [colors[2]]
		vertices_2d += [global_vertices[2]]
	elif not hit0 and hit1 and hit2:
		# Vertex 2
		colors_2d += [colors[2]]
		vertices_2d += [global_vertices[2]]
		# Hit 2
		colors_2d += [colors[2]]
		vertices_2d += [hit2]
		# Hit 1
		colors_2d += [colors[0]]
		vertices_2d += [hit1]
		# Vertex 0
		colors_2d += [colors[0]]
		vertices_2d += [global_vertices[0]]
		# Vertex 1
		colors_2d += [colors[1]]
		vertices_2d += [global_vertices[1]]
	else:
		colors_2d = colors
		vertices_2d = vertices
	
	# Draw
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(vertices_2d.size()):
		_mesh.surface_set_color(colors_2d[i])
		_mesh.surface_add_vertex(project(vertices_2d[i])) #TODO fix
	_mesh.surface_end()

func intersects_segment(vec1, vec2):
	return TinyPlane.plane.intersects_segment(vec1, vec2)

func project(vertex):
	return TinyPlane.plane.project(vertex)