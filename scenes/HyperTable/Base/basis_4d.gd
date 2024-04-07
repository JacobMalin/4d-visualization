class_name Basis4D

var x : Vector4 = Vector4.ZERO
var y : Vector4 = Vector4.ZERO
var z : Vector4 = Vector4.ZERO
var w : Vector4 = Vector4.ZERO

func _init(p_x = Vector4(1, 0, 0, 0), p_y = Vector4(0, 1, 0, 0),
		   p_z = Vector4(0, 0, 1, 0), p_w = Vector4(0, 0, 0, 1)):
	x = p_x
	y = p_y
	z = p_z
	w = p_w

static func newFromScaleAndRotation(scale, rot_1, rot_2):
	return newFromScale(scale).mul(newFromRotation(rot_1, rot_2))

static func newFromScale(scale):
	return Basis4D.new(
		Vector4(1, 0, 0, 0) * scale.x,
		Vector4(0, 1, 0, 0) * scale.y,
		Vector4(0, 0, 1, 0) * scale.z,
		Vector4(0, 0, 0, 1) * scale.w,
	)

static func newFromRotation(rot_1, rot_2):
	# Rotation Order : xy, yz, zx, xw, yw, zw
	# Rotation matrices taken from https://doi.org/10.1007/11919476_24
	var Rxy = Basis4D.new(
		Vector4(cos_deg(rot_1.x), -sin_deg(rot_1.x), 0, 0),
		Vector4(sin_deg(rot_1.x), cos_deg(rot_1.x), 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(0, 0, 0, 1),
	)
	var Ryz = Basis4D.new(
		Vector4(1, 0, 0, 0),
		Vector4(0, cos_deg(rot_1.y), -sin_deg(rot_1.y), 0),
		Vector4(0, sin_deg(rot_1.y), cos_deg(rot_1.y), 0),
		Vector4(0, 0, 0, 1),
	)
	var Rzx = Basis4D.new(
		Vector4(cos_deg(rot_1.z), 0, sin_deg(rot_1.z), 0),
		Vector4(0, 1, 0, 0),
		Vector4(-sin_deg(rot_1.z), 0, cos_deg(rot_1.z), 0),
		Vector4(0, 0, 0, 1),
	)
	var Rxw = Basis4D.new(
		Vector4(cos_deg(rot_2.x), 0, 0, sin_deg(rot_2.x)),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(-sin_deg(rot_2.x), 0, 0, cos_deg(rot_2.x)),
	)
	var Ryw = Basis4D.new(
		Vector4(1, 0, 0, 0),
		Vector4(0, cos_deg(rot_2.y), 0, sin_deg(rot_2.y)),
		Vector4(0, 0, 1, 0),
		Vector4(0, -sin_deg(rot_2.y), 0, cos_deg(rot_2.y)),
	)
	var Rzw = Basis4D.new(
		Vector4(1, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, cos_deg(rot_2.z), sin_deg(rot_2.z)),
		Vector4(0, 0, -sin_deg(rot_2.z), cos_deg(rot_2.z)),
	)

	return Rxy.mul(Ryz).mul(Rzx).mul(Rxw).mul(Ryw).mul(Rzw)

# Helper

func mul(rhs):
	var _basis = Basis4D.new()

	for i in range(4):
		for j in range(4):
			_basis.set_cell(i, j, row(i).dot(rhs.col(j)))

	return _basis

func row(i):
	if i == 0:   return x
	elif i == 1: return y
	elif i == 2: return z
	elif i == 3: return w

func a(i, j):
	return row(i-1)[j-1]

func col(j):
	var _col = Vector4.ZERO

	for i in range(4):
		_col[i] = row(i)[j]

	return _col

func set_cell(i, j, value):
	if i == 0:   x[j] = value
	elif i == 1: y[j] = value
	elif i == 2: z[j] = value
	elif i == 3: w[j] = value

static func cos_deg(theta):
	return cos(deg_to_rad(theta))

static func sin_deg(theta):
	return sin(deg_to_rad(theta))

func xform(p_vector):
	return Vector4(x.dot(p_vector), y.dot(p_vector), z.dot(p_vector), w.dot(p_vector))

func inverse():
	# inverse and det from the site:
	# http://www.cg.info.hiroshima-cu.ac.jp/~miyazaki/knowledge/teche23.html
	# with help from ChatGPT to transcribe it into text
	var det = \
		a(1,1) * ( \
			a(2,2) * ( a(3,3)*a(4,4) - a(3,4)*a(4,3) ) \
		  - a(2,3) * ( a(3,2)*a(4,4) - a(3,4)*a(4,2) ) \
		  + a(2,4) * ( a(3,2)*a(4,3) - a(3,3)*a(4,2) ) ) \
	  - a(1,2) * ( \
			a(2,1) * ( a(3,3)*a(4,4) - a(3,4)*a(4,3) ) \
		  - a(2,3) * ( a(3,1)*a(4,4) - a(3,4)*a(4,1) ) \
		  + a(2,4) * ( a(3,1)*a(4,3) - a(3,3)*a(4,1) ) ) \
	  + a(1,3) * ( \
			a(2,1) * ( a(3,2)*a(4,4) - a(3,4)*a(4,2) ) \
		  - a(2,2) * ( a(3,1)*a(4,4) - a(3,4)*a(4,1) ) \
		  + a(2,4) * ( a(3,1)*a(4,2) - a(3,2)*a(4,1) ) ) \
	  - a(1,4) * ( \
	  		a(2,1) * ( a(3,2)*a(4,3) - a(3,3)*a(4,2) ) \
		  - a(2,2) * ( a(3,1)*a(4,3) - a(3,3)*a(4,1) ) \
		  + a(2,3) * ( a(3,1)*a(4,2) - a(3,2)*a(4,1) ) )

	if (det == 0): push_error("Matrix determinant is 0.")

	var b11 =  a(2,2)*a(3,3)*a(4,4) - a(2,2)*a(3,4)*a(4,3) - a(2,3)*a(3,2)*a(4,4) + a(2,3)*a(3,4)*a(4,2) + a(2,4)*a(3,2)*a(4,3) - a(2,4)*a(3,3)*a(4,2)
	var b12 = -a(1,2)*a(3,3)*a(4,4) + a(1,2)*a(3,4)*a(4,3) + a(1,3)*a(3,2)*a(4,4) - a(1,3)*a(3,4)*a(4,2) - a(1,4)*a(3,2)*a(4,3) + a(1,4)*a(3,3)*a(4,2)
	var b13 =  a(1,2)*a(2,3)*a(4,4) - a(1,2)*a(2,4)*a(4,3) - a(1,3)*a(2,2)*a(4,4) + a(1,3)*a(2,4)*a(4,2) + a(1,4)*a(2,2)*a(4,3) - a(1,4)*a(2,3)*a(4,2)
	var b14 = -a(1,2)*a(2,3)*a(3,4) + a(1,2)*a(2,4)*a(3,3) + a(1,3)*a(2,2)*a(3,4) - a(1,3)*a(2,4)*a(3,2) - a(1,4)*a(2,2)*a(3,3) + a(1,4)*a(2,3)*a(3,2)

	var b21 = -a(2,1)*a(3,3)*a(4,4) + a(2,1)*a(3,4)*a(4,3) + a(2,3)*a(3,1)*a(4,4) - a(2,3)*a(3,4)*a(4,1) - a(2,4)*a(3,1)*a(4,3) + a(2,4)*a(3,3)*a(4,1)
	var b22 =  a(1,1)*a(3,3)*a(4,4) - a(1,1)*a(3,4)*a(4,3) - a(1,3)*a(3,1)*a(4,4) + a(1,3)*a(3,4)*a(4,1) + a(1,4)*a(3,1)*a(4,3) - a(1,4)*a(3,3)*a(4,1)
	var b23 = -a(1,1)*a(2,3)*a(4,4) + a(1,1)*a(2,4)*a(4,3) + a(1,3)*a(2,1)*a(4,4) - a(1,3)*a(2,4)*a(4,1) - a(1,4)*a(2,1)*a(4,3) + a(1,4)*a(2,3)*a(4,1)
	var b24 =  a(1,1)*a(2,3)*a(3,4) - a(1,1)*a(2,4)*a(3,3) - a(1,3)*a(2,1)*a(3,4) + a(1,3)*a(2,4)*a(3,1) + a(1,4)*a(2,1)*a(3,3) - a(1,4)*a(2,3)*a(3,1)

	var b31 =  a(2,1)*a(3,2)*a(4,4) - a(2,1)*a(3,4)*a(4,2) - a(2,2)*a(3,1)*a(4,4) + a(2,2)*a(3,4)*a(4,1) + a(2,4)*a(3,1)*a(4,2) - a(2,4)*a(3,2)*a(4,1)
	var b32 = -a(1,1)*a(3,2)*a(4,4) + a(1,1)*a(3,4)*a(4,2) + a(1,2)*a(3,1)*a(4,4) - a(1,2)*a(3,4)*a(4,1) - a(1,4)*a(3,1)*a(4,2) + a(1,4)*a(3,2)*a(4,1)
	var b33 =  a(1,1)*a(2,2)*a(4,4) - a(1,1)*a(2,4)*a(4,2) - a(1,2)*a(2,1)*a(4,4) + a(1,2)*a(2,4)*a(4,1) + a(1,4)*a(2,1)*a(4,2) - a(1,4)*a(2,2)*a(4,1)
	var b34 = -a(1,1)*a(2,2)*a(3,4) + a(1,1)*a(2,4)*a(3,2) + a(1,2)*a(2,1)*a(3,4) - a(1,2)*a(2,4)*a(3,1) - a(1,4)*a(2,1)*a(3,2) + a(1,4)*a(2,2)*a(3,1)

	var b41 = -a(2,1)*a(3,2)*a(4,3) + a(2,1)*a(3,3)*a(4,2) + a(2,2)*a(3,1)*a(4,3) - a(2,2)*a(3,3)*a(4,1) - a(2,3)*a(3,1)*a(4,2) + a(2,3)*a(3,2)*a(4,1)
	var b42 =  a(1,1)*a(3,2)*a(4,3) - a(1,1)*a(3,3)*a(4,2) - a(1,2)*a(3,1)*a(4,3) + a(1,2)*a(3,3)*a(4,1) + a(1,3)*a(3,1)*a(4,2) - a(1,3)*a(3,2)*a(4,1)
	var b43 = -a(1,1)*a(2,2)*a(4,3) + a(1,1)*a(2,3)*a(4,2) + a(1,2)*a(2,1)*a(4,3) - a(1,2)*a(2,3)*a(4,1) - a(1,3)*a(2,1)*a(4,2) + a(1,3)*a(2,2)*a(4,1)
	var b44 =  a(1,1)*a(2,2)*a(3,3) - a(1,1)*a(2,3)*a(3,2) - a(1,2)*a(2,1)*a(3,3) + a(1,2)*a(2,3)*a(3,1) + a(1,3)*a(2,1)*a(3,2) - a(1,3)*a(2,2)*a(3,1)

	return Basis4D.new(
		Vector4(b11, b12, b13, b14) / det,
		Vector4(b21, b22, b23, b24) / det,
		Vector4(b31, b32, b33, b34) / det,
		Vector4(b41, b42, b43, b44) / det,
	)