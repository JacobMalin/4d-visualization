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
		bounds.position + (bounds.scale / 2) * Vector3(-1, 0, 1),
		bounds.position + (bounds.scale / 2) * Vector3(-1, 0, -1),
		bounds.position + (bounds.scale / 2) * Vector3(1, 0, 1),
		bounds.position + (bounds.scale / 2) * Vector3(1, 0, -1),
	]

func _process(_delta):
	# Get plane eq
	normal = tiny_camera.transform.basis.y;
	d = normal.dot(tiny_camera.global_position - tiny_camera.offset - global_position)

	# New mesh
	_mesh.clear_surfaces()

	# Draw
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for corner in four_corners:
		var y = (d - normal.x * corner.x - normal.z * corner.z) / normal.y
		_mesh.surface_add_vertex(Vector3(corner.x, y, corner.z))
	_mesh.surface_end()

	# Set mesh
	mesh.mesh = _mesh

func _physics_process(_delta):
	position.y = tiny.position.y
