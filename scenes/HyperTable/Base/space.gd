# This class is heavily inspired by godot's Plane class
# https://github.com/godotengine/godot/blob/master/core/math/plane.cpp
class_name Space
extends Node

var normal : Vector4
var e = 0;

const EPSILON = 0.00001

func _init(p_normal = Vector4.ZERO, p_e = 0):
	normal = p_normal
	e = p_e

static func newFromABCDE(p_a, p_b, p_c, p_d, p_e = 0):
	return Space.new(Vector4(p_a, p_b, p_c, p_d), p_e)

static func newFromPoint(p_normal, p_point):
	var s = Space.new(p_normal)
	s.e = p_normal.dot(p_point)
	return s

func normalize():
	var l = normal.length()
	if (l == 0):
		normal = Vector4.ZERO
		e = 0
		return
		
	normal /= l
	e /= l


func normalized():
	var p = self.duplicate()
	p.normalize()
	return p

## Space-point operations

func get_center():
	return normal * e;

func is_point_over(p_point):
	return (normal.dot(p_point) > e)

func distance_to(p_point):
	return (normal.dot(p_point) - e)

func has_point(p_point, p_tolerance = EPSILON):
	var dist = normal.dot(p_point) - e;
	dist = abs(dist);
	return (dist <= p_tolerance);


## intersections

# func intersect_3(p_space1, p_space2):
# 	pass


# func intersects_ray(p_from, p_dir):
# 	pass


func intersects_segment(p_begin, p_end):
	var segment = p_begin - p_end;
	var den = normal.dot(segment);

	if is_zero_approx(den):
		return null

	var dist = (normal.dot(p_begin) - e) / den

	if dist < EPSILON or dist > (1 + EPSILON):
		return null

	dist = -dist

	return p_begin + segment * dist

	
func project(p_point):
	return p_point - normal * distance_to(p_point);


## misc

func _is_equal_approx(p_space):
	return normal.is_equal_approx(p_space.normal) and is_equal_approx(e, p_space.e)


func _is_finite():
	return normal.is_finite() and is_finite(e)


func _to_string():
	return "[N: " + str(normal) + ", D: " + str(e) + "]"
