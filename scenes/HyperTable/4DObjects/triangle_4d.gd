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
	# Draw
	_mesh_3d.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(3):
		_mesh_3d.surface_set_color(colors[i])
		# if do_normals: _mesh_3d.surface_set_normal(normals[i])
		# var vertex = vertices[i]
		var vertex = HyperReference.space.project(vertices[i])
		_mesh_3d.surface_add_vertex(Vector3(vertex.x, vertex.y, vertex.z))
	_mesh_3d.surface_end()
