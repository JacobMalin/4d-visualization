@tool
class_name HyperBox4D
extends Node4D

@export var size : Vector4 = Vector4.ONE : 
	set(s):
		size = s
		update_boxes()
		

# @export var colors: Color

@onready var boxes = [
	Box4D.new(),
	Box4D.new(),
	Box4D.new(),
	Box4D.new(),
	Box4D.new(),
	Box4D.new(),
]

func _ready():
	super._ready()

	for box in boxes:
		add_child(box)

	update_boxes()

func update_boxes():
	# Box 0 - +w
	boxes[0].size = Vector3(size.x, size.y, size.z)
	boxes[0].center_offset.w = size.w / 2
	boxes[0].update_visibility([true, true, true, true, true, true])
	# Box 1 - -w
	boxes[1].size = Vector3(size.x, size.y, size.z)
	boxes[1].center_offset.w = size.w / 2
	boxes[1].rotation_2.x = 180
	boxes[1].update_visibility([true, true, true, true, true, true])

	# Box 2 - +z
	boxes[2].size = Vector3(size.x, size.y, size.w)
	boxes[2].center_offset.w = size.z / 2
	boxes[2].rotation_2.z = 90
	boxes[2].update_visibility([false, false, true, true, true, true])
	# Box 3 - -z
	boxes[3].size = Vector3(size.x, size.y, size.w)
	boxes[3].center_offset.w = size.z / 2
	boxes[3].rotation_2.z = 270
	boxes[3].update_visibility([false, false, true, true, true, true])

	# Box 4 - +x
	boxes[4].size = Vector3(size.w, size.y, size.z)
	boxes[4].center_offset.w = size.x / 2
	boxes[4].rotation_2.x = 90
	boxes[4].update_visibility([false, false, false, false, true, true])
	# Box 5 - -x
	boxes[5].size = Vector3(size.w, size.y, size.z)
	boxes[5].center_offset.w = size.x / 2
	boxes[5].rotation_2.x = 270
	boxes[5].update_visibility([false, false, false, false, true, true])

	# Boxes 6 and 7 are omitted due to repeated faces

	scale = Vector3.ONE
	scale_w = 1.0

	# for box in boxes:
	# 	box.id = id
