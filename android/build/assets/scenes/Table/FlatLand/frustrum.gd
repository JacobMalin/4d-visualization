class_name Frustrum
extends Node3D

@export var tiny: Tiny

@onready var bounds: MeshInstance3D = tiny.bounds

@onready var arms = [
	$Arm,
	$Arm2,
	$Arm3,
	$Arm4,
]

@onready var planes = [
	[Vector3(1, 0, 0),  bounds.scale.x / 2 + bounds.global_position.x, true],
	[Vector3(1, 0, 0), -bounds.scale.x / 2 + bounds.global_position.x, true],
	[Vector3(0, 0, 1),  bounds.scale.z / 2 + bounds.global_position.z, false],
	[Vector3(0, 0, 1), -bounds.scale.z / 2 + bounds.global_position.z, false],
]

var tiny_pos

func _process(_delta):
	for arm in arms:
		var forwards = arm.global_transform.basis.y

		# Calc Length
		var hits = []
		for plane in planes:
			var normal = plane[0]
			var d = plane[1]
			var isX = plane[2]

			var t = (d - normal.dot(global_position)) / normal.dot(forwards)

			var reconstructed = global_position + forwards * t
			
			# Only allow points within the bounds
			if (isX  and (reconstructed.z < planes[2][1] and reconstructed.z > planes[3][1])) or \
			   (!isX and (reconstructed.x < planes[0][1] and reconstructed.x > planes[1][1])):
				if t > 0: hits += [t]

		var length = 0
		var dist = 0
		match hits.size():
			0:
				length = 0
				dist = length
			1:
				length = hits[0]
				dist = length / 2
			2:
				var close = hits.min()
				var far = hits.max()

				length = far - close
				dist = length / 2 + close

		# Move arm
		arm.global_position = global_position + forwards * dist

		# Scale arm
		arm.mesh.height = length
