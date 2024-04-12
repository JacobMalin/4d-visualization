# @tool
# class_name Box4D
# extends Node4D

# @export var size: Vector3 = Vector3.ONE
# @export var center_offset : Vector4

# @export var colors: Color

# @onready var squares = [
# 	Square3D.new(),
# 	Square3D.new(),
# 	Square3D.new(),
# 	Square3D.new(),
# 	Square3D.new(),
# 	Square3D.new(),
# ]

# func _ready():
# 	for square in squares:
# 		add_child(square)

# func _process(_delta):
# 	# Square 0 - +z
# 	squares[0].size = Vector2(size.x, size.y)
# 	squares[0].position.z = size.z / 2
# 	# Square 1 - -z
# 	squares[1].size = Vector2(size.x, size.y)
# 	squares[1].position.z = -size.z / 2
# 	squares[1].rotation_degrees.y = 180
# 	# Square 2 - +x
# 	squares[2].size = Vector2(size.z, size.y)
# 	squares[2].position.x = size.x / 2
# 	squares[2].rotation_degrees.y = 90
# 	# Square 3 - -x
# 	squares[3].size = Vector2(size.z, size.y)
# 	squares[3].position.x = -size.x / 2
# 	squares[3].rotation_degrees.y = 270
# 	# Square 4 - +y
# 	squares[4].size = Vector2(size.x, size.z)
# 	squares[4].position.y = size.y / 2
# 	squares[4].rotation_degrees.x = 270
# 	# Square 5 - -y
# 	squares[5].size = Vector2(size.x, size.z)
# 	squares[5].position.y = -size.y / 2
# 	squares[5].rotation_degrees.x = 90
