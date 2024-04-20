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
	# Box 1 - -w
	boxes[1].size = Vector3(size.x, size.y, size.z)
	boxes[1].center_offset.w = size.w / 2
	boxes[1].rotation_2.x = 180

	# Box 2 - +z
	boxes[2].size = Vector3(size.x, size.y, size.w)
	boxes[2].center_offset.w = size.z / 2
	boxes[2].rotation_2.z = 90
	# Box 3 - -z
	boxes[3].size = Vector3(size.x, size.y, size.w)
	boxes[3].center_offset.w = size.z / 2
	boxes[3].rotation_2.z = 270

	# Box 4 - +x
	boxes[4].size = Vector3(size.w, size.y, size.z)
	boxes[4].center_offset.w = size.x / 2
	boxes[4].rotation_2.x = 90
	# Box 5 - -x
	boxes[5].size = Vector3(size.w, size.y, size.z)
	boxes[5].center_offset.w = size.x / 2
	boxes[5].rotation_2.x = 270

	# Box 6 - +y
	boxes[6].size = Vector3(size.x, size.w, size.z)
	boxes[6].center_offset.w = size.y / 2
	boxes[6].rotation_2.y = 90
	# Box 7 - -y
	boxes[7].size = Vector3(size.x, size.w, size.z)
	boxes[7].center_offset.w = size.y / 2
	boxes[7].rotation_2.y = 270

	scale = Vector3.ONE
	scale_w = 1.0

	# for box in boxes:
	# 	box.id = id
