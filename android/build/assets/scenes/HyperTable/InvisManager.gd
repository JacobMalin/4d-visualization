extends Node3D

@export var triangle : Node3D
@export var square : Node3D
@export var cube : Node3D
@export var hypercube : Node3D
@export var axes : Node3D

signal invis_pushed(type)

func _ready():
	for i in [triangle, square, cube, hypercube]:
		i.invis_pushed.connect(_on_invis_pushed)

func _on_invis_pushed(_name):
	for i in [triangle, square, cube, hypercube]:
		i._on_invis_pushed(_name)