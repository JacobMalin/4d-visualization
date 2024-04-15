@tool
class_name Triangle4D
extends Node4D

@export var vertices = [
	Vector4(0, 1, 0, 0),
	Vector4(0, 0, 0, 0),
	Vector4(1, 1, 0, 0),
]

# @export var colors = [
# 	Color(),
# 	Color(),
# 	Color(),
# ]

@onready var mesh_3d = MeshInstance3D.new()
@onready var _mesh_3d = ImmediateMesh.new()
@onready var _mat_3d = preload("res://materials/hyper_3d_material.tres")

var uvs = [
	Vector2(0, 1),
	Vector2(0, 0),
	Vector2(1, 1),
]

func _ready():
	# Material
	mesh_3d.material_override = _mat_3d
	mesh_3d.extra_cull_margin = 10

	# Add children
	add_child(mesh_3d)

	# Clear mesh
	_mesh_3d.clear_surfaces()

	# Draw
	_mesh_3d.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(3):
		# _mesh_3d.surface_set_color(colors_3d[i])
		
		_mesh_3d.surface_set_uv(uvs[i])

		var vertex = vertices[i]
		_mesh_3d.surface_add_vertex(Vector3(vertex.x, vertex.y, vertex.z))
	_mesh_3d.surface_end()

	# Set mesh
	mesh_3d.mesh = _mesh_3d

func _process(_delta):
	draw()

	if Engine.is_editor_hint():
		pass

func draw():
	# Draw mesh
	draw_3d()

func draw_3d():	
	# Shader
	mesh_3d.set_instance_shader_parameter("vertex_0", vertices[0])
	mesh_3d.set_instance_shader_parameter("vertex_1", vertices[1])
	mesh_3d.set_instance_shader_parameter("vertex_2", vertices[2])

	var gtransform = _global_transform
	var gtransform_basis = gtransform.basis

	mesh_3d.set_instance_shader_parameter("origin", gtransform.origin)
	mesh_3d.set_instance_shader_parameter("basis_x", gtransform_basis.x)
	mesh_3d.set_instance_shader_parameter("basis_y", gtransform_basis.y)
	mesh_3d.set_instance_shader_parameter("basis_z", gtransform_basis.z)
	mesh_3d.set_instance_shader_parameter("basis_w", gtransform_basis.w)
