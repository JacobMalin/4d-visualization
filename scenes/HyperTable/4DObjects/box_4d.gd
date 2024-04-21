@tool
class_name Box4D
extends Node4D

@export var size : Vector3 = Vector3.ONE : 
	set(s):
		size = s
		update_rects.call_deferred()
@export var center_offset : Vector4 = Vector4.ZERO : 
	set(co):
		center_offset = co
		update_rects.call_deferred()

# @export var colors: Color

@onready var rects = [
	Rect4D.new(),
	Rect4D.new(),
	Rect4D.new(),
	Rect4D.new(),
	Rect4D.new(),
	Rect4D.new(),
]

func _ready():
	super._ready()
	
	for rect in rects:
		add_child(rect)

	update_rects()

func update_rects():
	for rect in rects:
		rect.center_offset = Vector4.ZERO

	# Rectangle 0 - +z
	rects[0].size = Vector2(size.x, size.y)
	rects[0].center_offset.z = size.z / 2
	rects[0].center_offset.x += center_offset.x
	rects[0].center_offset.y += center_offset.y
	rects[0].center_offset.z += center_offset.z
	rects[0].center_offset.w += center_offset.w
	# Rectangle 1 - -z
	rects[1].size = Vector2(size.x, size.y)
	rects[1].center_offset.z = size.z / 2
	rects[1].rotation_degrees.y = 180
	rects[1].center_offset.x -= center_offset.x
	rects[1].center_offset.y += center_offset.y
	rects[1].center_offset.z -= center_offset.z
	rects[1].center_offset.w += center_offset.w

	# Rectangle 2 - +x
	rects[2].size = Vector2(size.z, size.y)
	rects[2].center_offset.z = size.x / 2
	rects[2].rotation_degrees.y = 90
	rects[2].center_offset.x -= center_offset.z
	rects[2].center_offset.y += center_offset.y
	rects[2].center_offset.z += center_offset.x
	rects[2].center_offset.w += center_offset.w
	# Rectangle 3 - -x
	rects[3].size = Vector2(size.z, size.y)
	rects[3].center_offset.z = size.x / 2
	rects[3].rotation_degrees.y = 270
	rects[3].center_offset.x += center_offset.z
	rects[3].center_offset.y += center_offset.y
	rects[3].center_offset.z -= center_offset.x
	rects[3].center_offset.w += center_offset.w

	# Rectangle 4 - +y
	rects[4].size = Vector2(size.x, size.z)
	rects[4].center_offset.z = size.y / 2
	rects[4].rotation_degrees.x = 270
	rects[4].center_offset.x += center_offset.x
	rects[4].center_offset.y -= center_offset.z
	rects[4].center_offset.z += center_offset.y
	rects[4].center_offset.w += center_offset.w
	# Rectangle 5 - -y
	rects[5].size = Vector2(size.x, size.z)
	rects[5].center_offset.z = size.y / 2
	rects[5].rotation_degrees.x = 90
	rects[5].center_offset.x += center_offset.x
	rects[5].center_offset.y += center_offset.z
	rects[5].center_offset.z -= center_offset.y
	rects[5].center_offset.w += center_offset.w

	scale = Vector3.ONE
	scale_w = 1.0

	for rect in rects:
		rect.id = id

func update_visibility(vs):
	for i in range(6):
		rects[i].visible = vs[i]
