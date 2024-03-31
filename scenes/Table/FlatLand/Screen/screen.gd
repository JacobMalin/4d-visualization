@tool
class_name Screen
extends Node3D

@export var tiny : Tiny

@onready var sub_viewport : SubViewport = tiny.sub_viewport

@onready var mesh : MeshInstance3D = $Mesh

func _ready():
	mesh.mesh.material.albedo_texture = sub_viewport.get_texture()
