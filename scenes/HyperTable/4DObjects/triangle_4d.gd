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
@onready var _mat_3d = preload("res://materials/hyper_3d_material.tres").duplicate()

var uvs = [
	Vector2(0, 1),
	Vector2(0, 0),
	Vector2(1, 1),
]

func _ready():
	# Material
	mesh_3d.material_override = _mat_3d

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
	mesh_3d.material_override.set_shader_parameter("vertex_0", vertices[0])
	mesh_3d.material_override.set_shader_parameter("vertex_1", vertices[1])
	mesh_3d.material_override.set_shader_parameter("vertex_2", vertices[2])

	mesh_3d.material_override.set_shader_parameter("normal", HyperReference.space.normal)
	mesh_3d.material_override.set_shader_parameter("e", HyperReference.space.e)

	mesh_3d.material_override.set_shader_parameter("w_frustrum", HyperReference.w_frustrum)

	mesh_3d.material_override.set_shader_parameter("origin", _global_transform.origin)
	mesh_3d.material_override.set_shader_parameter("basis_x", _global_transform.basis.x)
	mesh_3d.material_override.set_shader_parameter("basis_y", _global_transform.basis.y)
	mesh_3d.material_override.set_shader_parameter("basis_z", _global_transform.basis.z)
	mesh_3d.material_override.set_shader_parameter("basis_w", _global_transform.basis.w)
