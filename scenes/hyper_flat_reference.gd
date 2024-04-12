extends Node

@export var space : Space = Space.new() : 
	set(s):
		space.normal = s.normal
		space.e = s.e
@export var camera_pos : Vector4 = Vector4.ZERO

@export var show_3d = true

@export var w_frustrum = 1