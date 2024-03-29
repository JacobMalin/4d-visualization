extends Area3D

@export var hand_skeleton : Skeleton3D
@export var bone_name : String

@export var offset : Vector3

var bone_index : int

# Called when the node enters the scene tree for the first time.
func _ready():
	bone_index = hand_skeleton.find_bone(bone_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position = offset + hand_skeleton.get_bone_global_pose(bone_index).origin
